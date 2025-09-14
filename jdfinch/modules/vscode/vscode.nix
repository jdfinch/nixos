{ config, pkgs, lib, ... }:

let
  filesLib    = import ../../../lib/link-hm-files.nix { inherit lib config; };
  repoRoot    = "${config.home.homeDirectory}/nixos";
  userRoot    = "${repoRoot}/${config.home.username}";
  worktreeAbs = "${userRoot}/modules/vscode/User";

  xdgLinks = filesLib.recFilesOnlyXdg {
    srcRel      = ./User;        # enumerate from flake source (pure)
    destPrefix  = "Code/User";   # → ~/.config/Code/User/*
    worktreeAbs = worktreeAbs;   # editable targets in your repo
  };

  # Extension IDs to install with `code --install-extension`
  extIds = [
    "mkhl.direnv"
    "jnoortheen.nix-ide"
    "ms-python.python"
    "ms-python.debugpy"
    "ms-python.vscode-pylance"
    "ms-toolsai.jupyter"
    "github.vscode-github-actions"
    "github.vscode-pull-request-github"
  ];
in
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    # Do NOT set profiles.default.extensions here; we’re managing via CLI.
  };

  # Keep your user settings linking
  xdg.configFile = xdgLinks;

  # Install extensions on each HM switch (simple presence check)
  home.activation.vscodeExtensions = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    set -euo pipefail

    # Ensure the writable extensions dir exists
    mkdir -p "$HOME/.vscode/extensions"

    if ! command -v code >/dev/null 2>&1; then
      echo "[vscode] 'code' not found in PATH; skipping extension install."
      exit 0
    fi

    installed="$(code --list-extensions || true)"

    for ext in ${lib.concatStringsSep " " extIds}; do
      echo "$installed" | grep -qx "$ext" || {
        echo "[vscode] Installing $ext"
        code --install-extension "$ext"
      }
    done
  '';
}
