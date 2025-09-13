{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      source ${./aliases.zsh}
      source ${./prompt.zsh}
      source ${./startup.zsh}

    '';
  };
}
