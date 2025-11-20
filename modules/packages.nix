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
    alsa-ucm-conf
    alsa-firmware
    alsa-tools
    pipewire
    wireplumber
    pulseaudio
    psmisc
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
    gimp3-with-plugins

  ];
  
}
