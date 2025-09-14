# jdfinch/home.nix
{ config, pkgs, lib, ... }:

let
  # bring in the helper
  recFilesOnlyXdg =
    (import ../lib/link-hm-files.nix { inherit lib config; }).recFilesOnlyXdg;

  # assume repo lives at ~/nixos
  repoRoot = "${config.home.homeDirectory}/nixos";
in
{
  imports = [
    ./modules/zsh/zsh.nix
    ./modules/vscode/vscode.nix
    ./modules/hyprland/hyprland.nix
  ];

  home = {
    username = "jdfinch";
    homeDirectory = config.home.homeDirectory;
    stateVersion = "24.11"; # stick to a released HM version
  };

  # link every file under nixos/jdfinch/home into $HOME
  xdg.configFile =
    recFilesOnlyXdg {
      srcRel      = ./home;                # the repo’s home subtree
      destPrefix  = "";                    # empty → place relative to $HOME
      worktreeAbs = "${repoRoot}/jdfinch/home";
    };

  programs.home-manager.enable = true;
}
