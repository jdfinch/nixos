#!/usr/bin/env bash
# reset-alsa-nixos.sh
# Reset ALSA (and common user audio state) to first-install defaults on NixOS.

set -euo pipefail

banner() { printf "\n==== %s ====\n" "$*"; }

need_root() {
  if [[ $EUID -ne 0 ]]; then
    echo "This script needs root for system-wide cleanup. Re-running with sudo..."
    exec sudo --preserve-env=HOME,BASH_SOURCE,BASH_ARGV "$0" "$@"
  fi
}

# Detect the real user even if invoked via sudo
REAL_USER=${SUDO_USER:-$USER}
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

timestamp=$(date +%Y%m%d-%H%M%S)
backup_dir="$REAL_HOME/.alsa-reset-backup-$timestamp"

banner "Stopping user audio daemons (PipeWire / PulseAudio / WirePlumber, if present)"
# Stop user services if they exist (ignore errors)
su - "$REAL_USER" -c 'systemctl --user stop pipewire.service pipewire.socket pipewire-pulse.service pipewire-pulse.socket wireplumber.service pulseaudio.service pulseaudio.socket 2>/dev/null || true'

banner "Backing up & removing user-level configs"
mkdir -p "$backup_dir"

move_if_exists() {
  local p="$1"
  if [[ -e "$p" ]]; then
    mkdir -p "$backup_dir/user"
    echo "Backing up $p -> $backup_dir/user/"
    mv "$p" "$backup_dir/user/" || true
  fi
}

# ALSA / Pulse / PipeWire user configs
move_if_exists "$REAL_HOME/.asoundrc"
move_if_exists "$REAL_HOME/.asoundrc.asoundconf"
move_if_exists "$REAL_HOME/.config/alsa"
move_if_exists "$REAL_HOME/.pulse"
move_if_exists "$REAL_HOME/.config/pulse"
move_if_exists "$REAL_HOME/.config/pipewire"
move_if_exists "$REAL_HOME/.local/state/wireplumber"
move_if_exists "$REAL_HOME/.cache/wireplumber"

# Ensure correct ownership after moving as root
PRIMARY_GROUP=$(id -gn "$REAL_USER")
chown -R "$REAL_USER":"$PRIMARY_GROUP" "$backup_dir" || true

banner "Clearing system ALSA mixer state"
# On NixOS, the state file typically lives here. Remove to force re-probe.
STATE_FILE="/var/lib/alsa/asound.state"
if [[ -e "$STATE_FILE" ]]; then
  mkdir -p "$backup_dir/system"
  echo "Backing up $STATE_FILE -> $backup_dir/system/"
  cp -a "$STATE_FILE" "$backup_dir/system/" || true
  rm -f "$STATE_FILE"
else
  echo "No $STATE_FILE found (that's fine)."
fi

# Some distros have restore/store units; try to stop them if present (harmless on NixOS if absent)
systemctl stop alsa-restore.service alsa-state.service alsa-store.service 2>/dev/null || true
systemctl disable alsa-restore.service alsa-state.service alsa-store.service 2>/dev/null || true

banner "Re-initializing ALSA cards (alsactl init)"
# Probe all cards by index; falls back to init without index if none
if [[ -r /proc/asound/cards ]]; then
  mapfile -t idxs < <(awk '/^\s*[0-9]+\s+\[/ {print $1}' /proc/asound/cards)
else
  idxs=()
fi

if [[ ${#idxs[@]} -gt 0 ]]; then
  for i in "${idxs[@]}"; do
    echo "alsactl init $i"
    alsactl init "$i" || true
  done
else
  echo "No card indices found; running plain alsactl init"
  alsactl init || true
fi

banner "Reloading user audio stack"
# Start user services back up (PipeWire preferred on modern NixOS)
systemctl --machine=jdfinch@.host --user daemon-reload
systemctl --machine=jdfinch@.host --user start pipewire.socket pipewire-pulse.socket wireplumber.service
# If you’re on PulseAudio instead of PipeWire:
systemctl --machine=jdfinch@.host --user start pulseaudio.socket pulseaudio.service

banner "Done"
echo "• User configs backed up in: $backup_dir"
echo "• ALSA state wiped and re-initialized."
echo "• User audio daemons restarted."

