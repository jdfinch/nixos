{ config, pkgs, lib, ... }:

let
  filesLib    = import ../../../lib/link-hm-files.nix { inherit lib config; };
  repoRoot    = "${config.home.homeDirectory}/nixos";
  userRoot    = "${repoRoot}/${config.home.username}";
  worktreeAbs = "${userRoot}/modules/vscode/User";

  xdgLinks = filesLib.recFilesOnlyXdg {
    srcRel      = ./User;
    destPrefix  = "Code/User";   # → ~/.config/Code/User/*
    worktreeAbs = worktreeAbs;
  };

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
    # do not set profiles.default.extensions here; we install via CLI
  };

  xdg.configFile = xdgLinks;

  home.activation.vscodeExtensions = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    set -euo pipefail

    # Use the Nix store path so PATH doesn't matter during activation
    codeBin="${pkgs.vscode}/bin/code"

    # Ensure writable extensions dir
    mkdir -p "$HOME/.vscode/extensions"

    # If VS Code isn't available, skip gracefully
    if [ ! -x "$codeBin" ]; then
      echo "[vscode] ${pkgs.vscode}/bin/code not found; skipping extension install."
      exit 0
    fi

    installed="$("$codeBin" --list-extensions || true)"

    for ext in ${lib.concatStringsSep " " extIds}; do
      if ! echo "$installed" | grep -qx "$ext"; then
        echo "[vscode] Installing $ext"
        "$codeBin" --install-extension "$ext"
      fi
    done
  '';
}
