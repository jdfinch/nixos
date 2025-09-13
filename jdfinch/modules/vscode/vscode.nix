# jdfinch/modules/vscode/vscode.nix
{ config, pkgs, ... }:

let
  repoRoot   = "${config.home.homeDirectory}/nixos";
  userRoot   = "${repoRoot}/${config.home.username}";
  userDirAbs = "${userRoot}/modules/vscode/User";

  extList    = import ./extensions.nix { inherit pkgs; };
in
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default.extensions = extList;
  };

  xdg.configFile."Code/User" = {
    source    = config.lib.file.mkOutOfStoreSymlink userDirAbs;
    recursive = true;
    force     = true;
  };
}
