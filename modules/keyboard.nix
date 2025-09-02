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
          semicolon = "right";

          j = "C-left";   # left word
          l = "C-right";  # right word

          o = "end";
          u = "home";

          k = "down";
          i = "up";

          n = "enter";
          y = "esc";
          b = "backspace";

          dot = "C-c";   # copy
          slash = "C-x"; # cut
          p = "C-v";   # paste

          apostrophe = "tab";

          space = "leftshift";
          
        };
      };
    };
  };
}

