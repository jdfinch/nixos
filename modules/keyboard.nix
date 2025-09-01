{ lib, config, pkgs, ... }:

{
  services.keyd = {
    enable = true;
  };

  users.groups.keyd = {};

  environment.etc."keyd/coder.conf".source = ./keyboard/coder.conf;
}

