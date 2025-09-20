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

  boot.plymouth.enable = true;                
  boot.consoleLogLevel = 3;                   # reduce kernel verbosity
  boot.kernelParams = [
    "quiet" "loglevel=3" "udev.log_priority=3"
    "vt.global_cursor_default=0"              # hide blinking TTY cursor
  ];
  boot.initrd.verbose = false;                # quiet initrd
  systemd.showStatus = false;                 # hide unit status spam
  boot.loader.systemd-boot.consoleMode = "auto";  # cleaner handoff
  

  system.stateVersion = "25.05";

  home-manager.users.jdfinch = import ../../jdfinch/home.nix;

}
