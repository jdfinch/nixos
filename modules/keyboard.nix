{ lib, config, pkgs, ... }:

{
  ############################################
  # 1) Keyd daemon
  ############################################
  services.keyd.enable = true;

  # (Optional: CLI handy for debugging: `keyd monitor -t`, `keyd list-keys`)
  environment.systemPackages = [ pkgs.keyd ];

  ############################################
  # 2) Write ONE keyd config (coder.conf)
  #    We manage the file ourselves to avoid any formatting quirks.
  ############################################
  environment.etc."keyd/coder.conf".text = ''
    [ids]
    *
    # ↑ grabs all keyboards. Once working, you can replace * with specific IDs like:
    # usb:1038:113a or by name, then rebuild.

    [main]
    # Hold Caps = enter 'nav' layer; tap Caps = no-op
    # (Change nop → esc if you want Caps to send Esc on tap.)
    capslock = overload(nav, nop)

    [nav]
    # While in nav: Space acts as Shift (Caps+Space = Shift)
    space = S

    # Home row / arrows & word-nav
    h = backspace
    j = C-left
    k = down
    l = C-right
    i = up

    # Top row helpers
    y = esc
    u = home
    o = end
    p = v

    # Bottom row helpers
    n = left
    m = enter
    comma = enter
    dot = right
    semicolon = z
    apostrophe = tab
    slash = c

    # Return → Backspace while in nav (matches your XKB intent)
    enter = backspace

    [combos]
    # Press together (no need to be in nav): Space+J = Ctrl+Shift+Left
    space+j = C-S-left
  '';

  ############################################
  # 3) Privileges & devices
  ############################################

  # keyd drops into the 'keyd' group; make sure it exists
  users.groups.keyd = {};

  # Create the uinput device for the “keyd virtual keyboard”
  hardware.uinput.enable = true;

  # Allow keyd to call setgid(2) and keep access to input/uinput
  systemd.services.keyd.serviceConfig = {
    RestrictSUIDSGID = lib.mkForce false;  # allow setgid
    NoNewPrivileges  = lib.mkForce false;  # allow the privilege drop
    User  = "root";
    Group = "root";
    SupplementaryGroups = [ "input" "uinput" "keyd" ];
  };

  ############################################
  # 4) (Optional) Help some Wayland setups recognize the virtual keyboard
  #    If your keys work right after a reboot, you can delete this.
  ############################################
  # environment.etc."libinput/local-overrides.quirks".text = ''
  #   [Serial Keyboards]
  #   MatchUdevType=keyboard
  #   MatchName=keyd virtual keyboard
  #   AttrKeyboardIntegration=internal
  # '';
}
