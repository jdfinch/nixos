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

  exts = import ./extensions.nix { inherit pkgs; };
in
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default.extensions = exts;
  };

  # Files-only links
  xdg.configFile = xdgLinks;
}
