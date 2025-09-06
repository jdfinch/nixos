{ config, pkgs, lib, ... }:

let
  homeDir = ./home;
in
{
  programs.home-manager.enable = true;

  imports = [
    ./modules/zsh/zsh.nix
    ./modules/vscode/vscode.nix
  ];

  home = {
    username = "jdfinch";
    homeDirectory = "/home/jdfinch";
    stateVersion = "25.05";

    # Mirror everything from jdfinch/home/ into $HOME
    file."." = {
      source = homeDir;
      recursive = true;
      force = true;  # optional but handy if files already exist
    };
  };
}
