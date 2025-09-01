# modules/system.nix
{ config, pkgs, lib, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Networking + DNS
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.enableIPv6 = false;
  services.resolved.enable = true;

  # Time & locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Keyboard
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Allow unfree
  nixpkgs.config.allowUnfree = true;

  # Shell
  programs.zsh.enable = true;

  # Firewall
  networking.firewall.enable = true;
}
