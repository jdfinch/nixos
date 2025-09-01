{ lib, config, pkgs, ... }:

{
  # Install the files exactly under /etc/xkb
  environment.etc."xkb/symbols/coder".source = ./xkb/coder;
  environment.etc."xkb/types/complete".source = ./xkb/complete;

  # Point both X11 and Wayland at /etc/xkb
  services.xserver.xkb.dir = "/etc/xkb";
  services.xserver.xkb.layout = "coder";
  services.xserver.xkb.variant = "basic";

  environment.sessionVariables = {
    XKB_DEFAULT_DIR     = "/etc/xkb";
    XKB_DEFAULT_RULES   = "evdev";
    XKB_DEFAULT_LAYOUT  = "coder";
    XKB_DEFAULT_VARIANT = "basic";
  };

  # Hyprland integration (append after our default config)
  environment.etc."hypr/hyprland.conf".text = lib.mkAfter ''
    input {
      kb_layout = coder
      kb_variant = basic
    }
  '';
}
