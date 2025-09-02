{ config, pkgs, ... }:

{
  # Install (optional; the service brings its own package, but this gives you the CLI too)
  environment.systemPackages = with pkgs; [ keyd ];

  services.keyd = {
    enable = true;

    # Start with a conservative, easy-to-undo mapping:
    keyboards.default = {
      # Apply to all keyboards for now (see step 2 to target a single device)
      ids = [ "*" ];

      # Simple, proven remaps
      settings.main = {
        # Tap Esc, hold Control — super common and low risk
        capslock = "overload(control, esc)";
        # Make sure Esc still exists somewhere if you change Caps later
        # leftalt = "leftmeta";  # uncomment if you want Alt↔Super swap
      };
    };
  };
}
