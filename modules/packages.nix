# modules/packages.nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    
    # essential system
    nixd
    git
    zsh
    pamixer
    brightnessctl
    wofi
    keyd xorg.xkbcomp xkeyboard_config xorg.setxkbmap

    # essential utils
    wget curl 
    which 
    zip unzip
    tree
    ffmpeg
    gcc
    python313

    # essential apps
    kitty
    vscode
    firefox

    # utils
    direnv

    # apps



  ];
  
}
