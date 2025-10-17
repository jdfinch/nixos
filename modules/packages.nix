# modules/packages.nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    
    # essential system
    nixd
    git
    zsh
    home-manager
    alsa-utils
    pipewire
    wireplumber
    pulseaudio
    pavucontrol
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
    python312
    python311
    python310

    # essential apps
    kitty
    vscode
    firefox

    # utils
    direnv
    swww
    uv
    conda

    # apps


  ];
  
}
