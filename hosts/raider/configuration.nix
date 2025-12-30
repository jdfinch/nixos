# hosts/raider/configuration.nix
{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/system.nix
    ../../modules/packages.nix
    ../../modules/hyprland.nix
    ../../modules/users.nix
    ../../modules/cuda.nix
    ../../modules/keyboard.nix
  ];
  
  networking.hostName = "raider";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;  

  hardware.enableRedistributableFirmware = true;

  services.hardware.bolt.enable = true;

  system.stateVersion = "25.05";

  home-manager.users.jdfinch = import ../../jdfinch/home.nix;

}
