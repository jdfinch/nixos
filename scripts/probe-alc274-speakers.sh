#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -ne 0 ]]; then
  echo "Run with sudo: sudo bash scripts/probe-alc274-speakers.sh" >&2
  exit 1
fi

codec=${CODEC:-/dev/snd/hwC0D0}
listener=${SUDO_USER:-jdfinch}
listener_uid=$(id -u "$listener")
runtime_dir="/run/user/${listener_uid}"
tone_log=$(mktemp)
tone_pid=

verb() {
  nix shell nixpkgs#alsa-tools -c hda-verb "$codec" "$@"
}

cleanup() {
  if [[ -n "${tone_pid}" ]] && kill -0 "$tone_pid" 2>/dev/null; then
    kill "$tone_pid" 2>/dev/null || true
    wait "$tone_pid" 2>/dev/null || true
  fi
  verb 0x01 SET_GPIO_DATA 0x00 >/dev/null 2>&1 || true
  verb 0x01 SET_GPIO_DIRECTION 0x00 >/dev/null 2>&1 || true
  verb 0x01 SET_GPIO_MASK 0x00 >/dev/null 2>&1 || true
  rm -f "$tone_log"
}
trap cleanup EXIT

echo "Starting a PipeWire speaker-test tone as ${listener}."
sudo -u "$listener" env XDG_RUNTIME_DIR="$runtime_dir" \
  speaker-test -D pipewire -c 2 -t sine -f 440 >"$tone_log" 2>&1 &
tone_pid=$!
sleep 2

if ! kill -0 "$tone_pid" 2>/dev/null; then
  echo "speaker-test failed; log follows:" >&2
  cat "$tone_log" >&2
  exit 1
fi

echo
echo "You should be listening for a 440Hz tone from the laptop speakers."
echo "Press Enter after each step. Type y if a step makes the speakers work."
echo

read -r -p "Baseline: do you hear the tone now? [y/N] " heard
if [[ "${heard,,}" == y* ]]; then
  echo "Baseline already works; no codec probe needed."
  exit 0
fi

for bit in 0x01 0x02 0x04 0x08; do
  echo
  echo "Trying GPIO ${bit} high."
  verb 0x01 SET_GPIO_MASK "$bit"
  verb 0x01 SET_GPIO_DIRECTION "$bit"
  verb 0x01 SET_GPIO_DATA "$bit"
  read -r -p "Do you hear laptop speakers with GPIO ${bit} high? [y/N] " heard
  if [[ "${heard,,}" == y* ]]; then
    echo "Working candidate: GPIO ${bit} high"
    exit 0
  fi

  echo "Trying GPIO ${bit} pulse-low state."
  verb 0x01 SET_GPIO_DATA 0x00
  sleep 1
  read -r -p "Do you hear laptop speakers after pulsing GPIO ${bit} low? [y/N] " heard
  if [[ "${heard,,}" == y* ]]; then
    echo "Working candidate: GPIO ${bit} pulse high then low"
    exit 0
  fi
done

echo
echo "Trying a small ALC274/ALC294 EAPD-style coefficient set."
for idx_val in "0x40 0x8800" "0x0f 0x7774" "0x45 0x5089"; do
  set -- $idx_val
  verb 0x20 SET_COEF_INDEX "$1"
  verb 0x20 SET_PROC_COEF "$2"
done
read -r -p "Do you hear laptop speakers after the coefficient set? [y/N] " heard
if [[ "${heard,,}" == y* ]]; then
  echo "Working candidate: ALC274/ALC294 coefficient set"
  exit 0
fi

echo
echo "No tested runtime candidate worked. Rebooting will clear these codec experiments."
