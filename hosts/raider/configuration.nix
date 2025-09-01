# hosts/raider/configuration.nix
{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    # shared modules (apply to every machine)
    ../../modules/system.nix
    ../../modules/packages.nix
    ../../modules/gui.nix
    ../../modules/users.nix
    ../../modules/cuda.nix
  ];

  my.cuda.enable = true;
  my.cuda.toolkitVersion = "12.8";

  # host-specific bits
  networking.hostName = "raider";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.getty.autologinUser = "jdfinch";

  system.stateVersion = "25.05";
}
