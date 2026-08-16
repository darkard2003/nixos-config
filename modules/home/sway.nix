{
  pkgs,
  self,
  ...
}:

{
  wayland.systemd.target = "sway-session.target";
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
    systemd.xdgAutostart = true;
    checkConfig = false;

    config = null;

    extraConfig = ''
      include ${self}/dotfiles/sway/config
    '';
  };
}
