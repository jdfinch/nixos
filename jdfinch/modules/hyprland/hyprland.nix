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
        natural_scroll = true;
        touchpad = {
          natural_scroll = true;
          "tap-to-click" = true;
        };
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;  # no default wallpaper/splash → black background
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
        bezier = "ease, 0.05, 0.9, 0.1, 1.0";
        animation = [
          "windows, 1, 7, ease, slide"
          "border, 1, 10, default"
          "fade, 1, 10, default"
        ];
      };

      "$mod" = "SUPER";

      bind = [
        # --- existing ---
        "$mod, Return, exec, kitty"
        "$mod, E, exec, wofi --show drun"
        "$mod, Q, killactive"
        "$mod, F, fullscreen"

        # --- Brightness control ---
        ",XF86MonBrightnessUp, exec, brightnessctl set +3%"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"

        # =========================
        # Super-based workflow
        # =========================

        # Workspaces: jump to 1–10 (0 = 10)
        "$mod,1,workspace,1"
        "$mod,2,workspace,2"
        "$mod,3,workspace,3"
        "$mod,4,workspace,4"
        "$mod,5,workspace,5"
        "$mod,6,workspace,6"
        "$mod,7,workspace,7"
        "$mod,8,workspace,8"
        "$mod,9,workspace,9"
        "$mod,0,workspace,10"

        # Relative workspace navigation
        "$mod,LEFT,workspace,-1"
        "$mod,RIGHT,workspace,+1"

        # Move focused window to previous/next workspace AND follow
        "$mod CTRL, LEFT,  exec, hyprctl dispatch movetoworkspace r-1; hyprctl dispatch workspace -1"
        "$mod CTRL, RIGHT, exec, hyprctl dispatch movetoworkspace r+1; hyprctl dispatch workspace +1"


        # Send active window to workspace (silent = don't follow)
        "$mod SHIFT,1,movetoworkspacesilent,1"
        "$mod SHIFT,2,movetoworkspacesilent,2"
        "$mod SHIFT,3,movetoworkspacesilent,3"
        "$mod SHIFT,4,movetoworkspacesilent,4"
        "$mod SHIFT,5,movetoworkspacesilent,5"
        "$mod SHIFT,6,movetoworkspacesilent,6"
        "$mod SHIFT,7,movetoworkspacesilent,7"
        "$mod SHIFT,8,movetoworkspacesilent,8"
        "$mod SHIFT,9,movetoworkspacesilent,9"
        "$mod SHIFT,0,movetoworkspacesilent,10"

        # Send & FOLLOW: move window, then switch to that workspace
        "$mod CTRL,1,exec,hyprctl dispatch movetoworkspace 1; hyprctl dispatch workspace 1"
        "$mod CTRL,2,exec,hyprctl dispatch movetoworkspace 2; hyprctl dispatch workspace 2"
        "$mod CTRL,3,exec,hyprctl dispatch movetoworkspace 3; hyprctl dispatch workspace 3"
        "$mod CTRL,4,exec,hyprctl dispatch movetoworkspace 4; hyprctl dispatch workspace 4"
        "$mod CTRL,5,exec,hyprctl dispatch movetoworkspace 5; hyprctl dispatch workspace 5"
        "$mod CTRL,6,exec,hyprctl dispatch movetoworkspace 6; hyprctl dispatch workspace 6"
        "$mod CTRL,7,exec,hyprctl dispatch movetoworkspace 7; hyprctl dispatch workspace 7"
        "$mod CTRL,8,exec,hyprctl dispatch movetoworkspace 8; hyprctl dispatch workspace 8"
        "$mod CTRL,9,exec,hyprctl dispatch movetoworkspace 9; hyprctl dispatch workspace 9"
        "$mod CTRL,0,exec,hyprctl dispatch movetoworkspace 10; hyprctl dispatch workspace 10"

        # Next empty workspace helpers
        "$mod,N,workspace,empty"
        "$mod SHIFT,N,movetoworkspacesilent,empty"
        "$mod CTRL,N,exec,hyprctl dispatch movetoworkspace empty; hyprctl dispatch workspace empty"

        # Monitors (screens): focus & move window
        "$mod SHIFT,LEFT,movewindow,mon:prev"
        "$mod SHIFT,RIGHT,movewindow,mon:next"

        # Floating: toggle & center (Super+T to avoid fullscreen clash)
        "$mod,T,togglefloating"
        "$mod,C,centerwindow"

        # Super+Ctrl+Arrow to resize stepwise
        "$mod ALT, UP,    resizeactive, 0 -100"   # shrink vertically
        "$mod ALT, DOWN,  resizeactive, 0 100"    # grow vertically
        "$mod ALT, LEFT,  resizeactive, -100 0"   # shrink horizontally
        "$mod ALT, RIGHT, resizeactive, 100 0"    # grow horizontally
      ];

      # Mouse helpers for floating (Super + Left drag = move, Right drag = resize)
      bindm = [
        "$mod,mouse:272,movewindow"
        "$mod,mouse:273,resizewindow"
      ];

      binde = [
        # --- Volume control ---
        ",XF86AudioRaiseVolume, exec, pamixer -u -i 3"
        ",XF86AudioLowerVolume, exec, pamixer -d 5"
      ];
    };
  };
}
