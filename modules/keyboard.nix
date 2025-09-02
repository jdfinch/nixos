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

          n = "left";
          dot = "right";

          j = "C-left";   # left word
          l = "C-right";  # right word

          o = "end";
          u = "home";

          k = "down";
          i = "up";

          m = "enter";
          y = "esc";
          h = "backspace";

          slash = "C-c";   # copy
          p = "C-v";   # paste
          
        };
      };
    };
  };
}

