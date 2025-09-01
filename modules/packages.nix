# modules/packages.nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    foot 
    waybar wofi 
    firefox
    python313 gcc 
    ffmpeg
    zsh git wget curl jq which zip unzip
    xorg.xkbcomp xkeyboard_config xorg.setxkbmap
    vscode
  ];
}
