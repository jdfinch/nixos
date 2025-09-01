# hosts/raider/configuration.nix
{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/system.nix
    ../../modules/packages.nix
    ../../modules/gui.nix
    ../../modules/users.nix
    ../../modules/cuda.nix
  ];
  
  networking.hostName = "raider";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.getty.autologinUser = "jdfinch";

  system.stateVersion = "25.05";
}
