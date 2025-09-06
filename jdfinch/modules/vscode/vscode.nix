{ config, pkgs, ... }:

let
  vscodeDir = ../vscode;
  extList   = import (vscodeDir + "/extensions.nix") { inherit pkgs; };
in
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default.extensions = extList;
  };

  # Symlink the entire VSCode User directory from your repo
  xdg.configFile."Code/User" = {
    source = vscodeDir;
    recursive = true;
  };

}
