{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # This replaces the default prompt
    promptInit = ''
      PS1="%B%F{white}%K{blue}(%<...<%~)%<<%f%k > %b"
    '';

    # Keep zsh config here to avoid conflicts with a .zshrc in jdfinch/home/
    initContent = ''
      alias renix='sudo nixos-rebuild switch --flake ~/nixos#raider'
    '';
  };
}
