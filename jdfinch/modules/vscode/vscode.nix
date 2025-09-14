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

  # List of extension IDs for `code --install-extension`
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
    # Keep the dir writable; we'll install via CLI
    mutableExtensionsDir = true;
  };

  # Files-only links (your existing setup)
  xdg.configFile = xdgLinks;

  # Install/ensure extensions on each HM switch (idempotent)
  home.activation.vscodeExtensions = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    set -eu
    ext_dir="$HOME/.vscode/extensions"
    mkdir -p "$ext_dir"

    # Prefer code, fall back to codium if present
    CODE_BIN="$(command -v code || true)"
    if [ -z "$CODE_BIN" ]; then
      CODE_BIN="$(command -v codium || true)"
    fi

    if [ -z "$CODE_BIN" ]; then
      echo "[vscode] 'code' (or 'codium') not found in PATH; skipping extension install."
      exit 0
    fi

    # Install any missing extensions
    for ext in ${lib.concatStringsSep " " extIds}; do
      if ! "$CODE_BIN" --list-extensions | grep -qi "^$ext$"; then
        echo "[vscode] Installing $ext"
        "$CODE_BIN" --install-extension "$ext" --force || true
      fi
    done
  '';
}
