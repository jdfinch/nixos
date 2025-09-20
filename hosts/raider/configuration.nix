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

  boot.plymouth.enable = true;            # splash; disable if you want pure black

  # Quieter kernel + systemd
  boot.consoleLogLevel = 3;
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "udev.log_priority=3"
    "vt.global_cursor_default=0"  # hide blinking TTY cursor
    "systemd.show_status=false"   # replaces old systemd.showStatus
  ];

  boot.initrd.verbose = false;
  boot.loader.systemd-boot.consoleMode = "auto";
  

  system.stateVersion = "25.05";

  home-manager.users.jdfinch = import ../../jdfinch/home.nix;

}
