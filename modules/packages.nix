# modules/packages.nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nixd
    foot 
    waybar wofi 
    firefox
    python313 gcc 
    ffmpeg
    zsh git wget curl jq which zip unzip
    tree
    keyd xorg.xkbcomp xkeyboard_config xorg.setxkbmap
    vscode
  ];
  
}
