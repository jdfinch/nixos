# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];
  networking.enableIPv6 = false;

  services.resolved.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jdfinch = {
    isNormalUser = true;
    description = "James Finch";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "jdfinch";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.hyprland.enable = true;
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    # alsa.support32bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    nerd-fonts.fira-code
  ];


  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --greeting 'Hello, world.' --cmd '${pkgs.hyprland}/bin/hyprland -c /etc/hypr/hyprland.conf'";
      user = "greeter";
    };
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    foot
    waybar
    wofi
    firefox
    python313
    gcc
    ffmpeg
    wget
    curl
    git
    jq
    which
    zsh    
    xorg.xkbcomp
    xkeyboard_config
    vscode
  ];

  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  programs.zsh.enable = true;
  
  environment.etc."hypr/hyprland.conf".text = ''
  monitor=,preferred,auto,1
  
  input {
    follow_mouse = 1
    touchpad { natural_scroll = true; tap-to-click = true; }
  }

  general {
    gaps_in = 6
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(89b4faee) rgba(f38ba8ee) 45deg
    col.inactive_border = rgba(1e1e2eee)
  }

  decoration {
    rounding = 8
    blur { enabled = true; size = 5; passes = 2; }
  }

  animations {
    enabled = true;
    bezier = ease, 0.05, 0.9, 0.1, 1.0
    animation = windows, 1, 7, ease, slide
    animation = border, 1, 10, default
    animation = fade, 1, 10, default
  }
  
  exec-once = foot
  exec-once = waybar
  
  $mod = SUPER
  bind = $mod, Return, exec, foot
  bind = $mod, E, exec, wofi --show drun
  bind = $mod, Q, killactive
  bind = $mod, F, fullscreen
  bind = $mod, SHIFT, E, exit
  
  '';

  environment.etc."waybar/config".text = ''
  {
    "layer": "top",
    "position": "top",
    "modules-left": ["hyprland/workspaces", "hyprland/window"],
    "modules-center": ["clock"],
    "modules-right": ["pulseaudio", "network", "battery", "tray"]
  }
  '';

  networking.firewall.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
