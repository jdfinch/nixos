{ config, pkgs, ... }:

{
  services.keyd = {
    enable = true;

    keyboards.default = {
      ids = [ "*" ];  # or your specific VID:PID if you scoped earlier

      settings = {
        # Hold Caps = enter the "nav" layer
        main.capslock = "layer(nav)";

        # --- Define the nav layer ---
        # Vim-style arrows on HJKL, plus common nav keys
        nav = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";

          u = "home";
          o = "end";
          y = "pageup";
          i = "pagedown";

          # Word-wise movement while in nav:
          b = "C-left";     # back a word
          n = "C-right";    # forward a word

          # Editing helpers:
          d = "delete";
          x = "backspace";

          # Selection helpers (shifted arrows):
          H = "S-left";
          J = "S-down";
          K = "S-up";
          L = "S-right";
        };
      };
    };
  };
}

