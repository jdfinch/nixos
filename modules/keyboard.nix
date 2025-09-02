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
        nav = {

          h = "left";
          semicolon = "right";

          j = "C-left";   # left word
          l = "C-right";  # right word

          o = "end";
          u = "home";

          k = "down";
          i = "up";

          leftbrace = "pageup";
          rightbrace = "pagedown";

          n = "enter";
          y = "esc";
          b = "backspace";
          apostrophe = "tab";

          dot = "C-c";   # copy
          slash = "C-x"; # cut
          p = "C-v";   # paste
          comma = "C-z"; # undo 

          space = "leftshift";
          
        };
      };
    };
  };
}

