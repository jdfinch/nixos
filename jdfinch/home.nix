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
    ./modules/gtk/gtk.nix
    ./modules/godot/godot.nix
  ];

  home = {
    username = "jdfinch";
    homeDirectory =  "/home/${config.home.username}";
    stateVersion = "24.11"; # stick to a released HM version
  };

  # link every file under nixos/jdfinch/home into $HOME
  xdg.configFile =
    recFilesOnlyXdg {
      srcRel      = ./home;                # the repo’s home subtree
      destPrefix  = "";                    # empty → place relative to $HOME
      worktreeAbs = "${repoRoot}/jdfinch/home";
    };

  home.activation.comfyuiSetup = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    mkdir -p "${config.home.homeDirectory}/.local/bin"
    mkdir -p "${config.home.homeDirectory}/.local/share/applications"

    ln -sfn \
      "${repoRoot}/jdfinch/home/.local/bin/comfyui-hm" \
      "${config.home.homeDirectory}/.local/bin/comfyui-hm"
    ln -sfn \
      "${repoRoot}/jdfinch/home/.local/share/applications/comfyui.desktop" \
      "${config.home.homeDirectory}/.local/share/applications/comfyui.desktop"
  '';

  programs.home-manager.enable = true;
}
