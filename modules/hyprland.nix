# modules/hyprland.nix  (system-level)
{ pkgs, ... }:
{
  programs.hyprland.enable = true;

  # Wayland-friendly env (keep here if you want global)
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  # Helpful Wayland bits for Qt
  environment.systemPackages = with pkgs; [
    qt6.qtwayland
    qt5.qtwayland
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    # Prefer Hyprland portal; keep gtk for some apps
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    # Make Hyprland the default if needed
    config.common.default = [ "hyprland" "gtk" ];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    nerd-fonts.fira-code
  ];

  services.greetd = {
    enable = true;
    settings.default_session = {

      # Quiet login
      enable = true;
      tty = 1;  # stick to tty1 to avoid flicker
      command = "${pkgs.hyprland}/bin/hyprland";
      user = "jdfinch";

      # For manual login:
      # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --greeting 'Hello, world.' --cmd ${pkgs.hyprland}/bin/hyprland";
      # user = "greeter";
    };
  };

}
