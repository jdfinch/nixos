# jdfinch/modules/vscode/vscode.nix
{ config, pkgs, ... }:

let
  userDir = ./User;                         
  extList = import ./extensions.nix { inherit pkgs; }; 
in
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default.extensions = extList;
  };

  # Link into ~/.config/Code/User
  xdg.configFile."Code/User" = {
    source = userDir;
    recursive = true;
    force = true;
  };
}
