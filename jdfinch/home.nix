{ config, pkgs, lib, ... }:

let
  homeDir = ./home;
  entries = builtins.readDir homeDir;

  mkHomeFile = name: typ:
    let src = "${homeDir}/${name}";
    in if typ == "directory" then
      { source = src; recursive = true; force = true; }
    else
      { source = src; force = true; };
in
{
  programs.home-manager.enable = true;

  imports = [
    ./modules/zsh/zsh.nix
    ./modules/vscode/vscode.nix
    ./modules/hyprland/hyprland.nix
  ];

  home = {
    username = "jdfinch";
    homeDirectory = "/home/jdfinch";
    stateVersion = "25.05";

    # Link everything under ./home into $HOME (top-level items only)
    file = builtins.mapAttrs mkHomeFile entries;
  };
}
