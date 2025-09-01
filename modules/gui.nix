# modules/gui.nix
{ pkgs, ... }:
{
  programs.hyprland.enable = true;

  # Wayland/Hypr env
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  services.pipewire = {
    enable = true; 
    alsa.enable = true; 
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
    noto-fonts noto-fonts-emoji nerd-fonts.fira-code
  ];

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --greeting 'Hello, world.' --cmd '${pkgs.hyprland}/bin/hyprland -c /etc/hypr/hyprland.conf'";
      user = "greeter";
    };
  };

  environment.etc."hypr/hyprland.conf".text = ''
    monitor=,preferred,auto,1
    input { follow_mouse = 1; touchpad { natural_scroll = true; tap-to-click = true; } }
    general { gaps_in = 6; gaps_out = 10; border_size = 2;
              col.active_border = rgba(89b4faee) rgba(f38ba8ee) 45deg;
              col.inactive_border = rgba(1e1e2eee) }
    decoration { rounding = 8; blur { enabled = true; size = 5; passes = 2; } }
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
}
