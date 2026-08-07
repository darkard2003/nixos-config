{ config, pkgs, ... }:

{
  # Display Manager & Window Manager
  services.displayManager.ly.enable = true;

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
  };

  # XDG Desktop Portals
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "wlr" "gtk" ];
  };

  # Polkit & Keyring Security
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.ly.enableGnomeKeyring = true;
  security.pam.services.swaylock = {};
}
