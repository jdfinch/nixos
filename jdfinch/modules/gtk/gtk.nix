# jdfinch/modules/gtk/gtk.nix
{ pkgs, ... }:
{
  gtk = {
    enable = true;

    # Dark theme for GTK3/GTK4 + portals
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    # Icons & cursor so dialogs look complete
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
  };

  # Tell GTK4 apps to prefer dark mode, even outside GNOME
  dconf.enable = true;
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
}
