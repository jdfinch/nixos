{ config, pkgs, ... }:

let
  vscodeDir = ../vscode;
  extList   = import (vscodeDir + "/extensions.nix") { inherit pkgs; };
in
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    extensions = extList;
  };

  # Symlink the entire VSCode User directory from your repo
  xdg.configFile."Code/User" = {
    source = vscodeDir;
    recursive = true;
  };

  # For VSCodium or Insiders, swap the target:
  # xdg.configFile."VSCodium/User".source = vscodeDir;
  # xdg.configFile."Code - Insiders/User".source = vscodeDir;
}
