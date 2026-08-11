{
  pkgs,
  self,
  ...
}:

{
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
    systemd.xdgAutostart = true;
    checkConfig = false;

    config = null;

    extraConfig = ''
      include ${self}/sway/config
    '';
  };
}
