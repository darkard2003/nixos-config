{ pkgs, ... }:

{
  services.displayManager.ly = {
    enable = true;
    settings = {
      # Visuals
      bigclock = true;
      clock = "%Y-%m-%d %H:%M:%S";
      animate = true;
      animation = 1;

      # Behavior
      load = true;
      save = true;
      asterisks = true;
      wayland_specifier = true;

      bg = 0;
      fg = 7;
      border_fg = 8;
    };
  };

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
  };

  xdg.autostart.enable = true;

  # XDG Desktop Portals
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [
      "wlr"
      "gtk"
    ];
  };

  # Polkit & Keyring Security
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.ly.enableGnomeKeyring = true;
  security.pam.services.swaylock = { };
}
