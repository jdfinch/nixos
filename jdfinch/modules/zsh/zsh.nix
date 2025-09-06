{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    # Keep zsh config here to avoid conflicts with a .zshrc in jdfinch/home/
    initExtra = ''
      alias renix='sudo nixos-rebuild switch --flake ~/nixos#raider'
    '';
  };
}
