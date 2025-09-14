# jdfinch/modules/hyprland.nix
{ config, pkgs, ... }:
{
  # Hyprland per-user config
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;

    # If you need XWayland:
    # xwayland.enable = true;

    settings = {
      monitor = [ ",preferred,auto,1" ];

      input = {
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
          "tap-to-click" = true;
        };
      };

      "exec-once" = [
        "swww-daemon"
      ];

      general = {
        gaps_in = 6;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(89b4faee) rgba(f38ba8ee) 40deg";
        "col.inactive_border" = "rgba(1e1e2eee)";
      };

      decoration = {
        rounding = 8;
        blur = { enabled = true; size = 5; passes = 2; new_optimizations=true; };
        active_opacity = 0.9;
        inactive_opacity = 0.8;
      };

      animations = {
        enabled = true;
        # Strings and lists map 1:1 to Hyprland directives
        bezier = "ease, 0.05, 0.9, 0.1, 1.0";
        animation = [
          "windows, 1, 7, ease, slide"
          "border, 1, 10, default"
          "fade, 1, 10, default"
        ];
      };

      "$mod" = "SUPER";

      bind = [
        "$mod, Return, exec, kitty"
        "$mod, E, exec, wofi --show drun"
        "$mod, Q, killactive"
        "$mod, F, fullscreen"

        # --- Brightness control ---
        ",XF86MonBrightnessUp, exec, brightnessctl set +3%"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      binde = [
        # --- Volume control ---
        ",XF86AudioRaiseVolume, exec, pamixer -u -i 3"
        ",XF86AudioLowerVolume, exec, pamixer -d 5"
      ];

    };
  };

}

