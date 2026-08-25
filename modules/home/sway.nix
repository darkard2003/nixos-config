{
  pkgs,
  config,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos-config/dotfiles";
in

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
      include ${dotfiles}/sway/config
    '';
  };
}
