{ config, pkgs, ... }:

{
  services.swaync.enable = true;
  xdg.configFile."swaync/config.json".enable = false;
  xdg.configFile."swaync/style.css".enable = false;

  services.wlsunset = {
    enable = true;
    latitude = "22.9";
    longitude = "88.4";
  };

  services.cliphist.enable = true;

  services.kanshi.enable = true;

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock-effects}/bin/swaylock -f -C ~/.cache/wallust/swaylock-config 2>/dev/null || ${pkgs.swaylock-effects}/bin/swaylock -f";
      }
      {
        timeout = 600;
        command = "${pkgs.sway}/bin/swaymsg 'output * power off'";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * power on'";
      }
    ];
    events = {
      before-sleep = "${pkgs.swaylock-effects}/bin/swaylock -f -C ~/.cache/wallust/swaylock-config 2>/dev/null || ${pkgs.swaylock-effects}/bin/swaylock -f";
    };
  };
}
