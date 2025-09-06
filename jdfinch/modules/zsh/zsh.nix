{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Keep zsh config here to avoid conflicts with a .zshrc in jdfinch/home/
    initContent = ''
      alias renix='sudo nixos-rebuild switch --flake ~/nixos#raider'
    '';
  };
}
