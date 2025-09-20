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


  # Quiet splashy boot
  boot.plymouth.enable = true;   # shows splash; press Esc for logs if you want

  # Kernel + systemd (real userspace) quieting
  boot.consoleLogLevel = 1;      # stricter than 3 (almost nothing)
  boot.kernelParams = [
    "quiet"
    "loglevel=1"
    "udev.log_priority=3"
    "systemd.show_status=false"
    # Send console messages to a non-visible VT so tty1 stays clean
    "console=tty12"
    "rd.systemd.show_status=false"
    "rd.udev.log_priority=3"
  ];

  # Initrd quieting (systemd-in-initrd & udev there)
  boot.initrd.verbose = false;

  # Optional but often nicer handoff
  boot.loader.systemd-boot.consoleMode = "auto";

  

  system.stateVersion = "25.05";

  home-manager.users.jdfinch = import ../../jdfinch/home.nix;

}
