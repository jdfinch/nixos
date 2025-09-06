{ config, pkgs, lib, ... }:

let
  homeDir = ./home;
in
{
  programsn.home-manager.enable = true;

  # Pull in feature modules
  imports = [
    ./modules/zsh/zsh.nix
    ./modules/vscode/vscode.nix
  ];

  home.username = "jdfinch";
  home.homeDirectory = "/home/jdfinch";
  home.stateVersion = "25.05";

  # Mirror everything from jdfinch/home/ into $HOME
  home.file."." = {
    source = homeDir;
    recursive = true;
  };

  home.activation.ensureConfigDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config"
  '';
}
