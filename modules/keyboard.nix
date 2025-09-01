{ lib, config, pkgs, ... }:

{
  services.keyd = {
    enable = true;
    keyboards = {
      # The name is just the name of the configuration file, it does not really matter
      default = {
        ids = [ "*" ]; # what goes into the [id] section, here we select all keyboards
        # Everything but the ID section:
        settings = {
          # The main layer, if you choose to declare it in Nix
          main = {
            capslock = "layer(control)"; # you might need to also enclose the key in quotes if it contains non-alphabetical symbols
          };
          otherlayer = {};
        };
        extraConfig = ''
          # put here any extra-config, e.g. you can copy/paste here directly a configuration, just remove the ids part
        '';
      };
    };
  };

  # group that keyd wants to drop to
  users.groups.keyd = {};

  # uinput for the virtual keyboard
  hardware.uinput.enable = true;

  # relax hardening so keyd can setgid to the 'keyd' group
  systemd.services.keyd.serviceConfig = {
    RestrictSUIDSGID = lib.mkForce false;
    NoNewPrivileges  = lib.mkForce false;
    User  = "root";
    Group = "root";
    SupplementaryGroups = [ "input" "uinput" "keyd" ];
  };

}

