{ config, pkgs, ... }:

{
  services.swaync.enable = true;
  xdg.configFile."swaync/config.json".enable = false;
  xdg.configFile."swaync/style.css".enable = false;

  services.wlsunset = {
    enable = true;
    sunrise = "06:00";
    sunset = "18:30";
    systemdTarget = "sway-session.target";
  };

  services.cliphist.enable = true;

  services.kanshi.enable = true;
  services.kdeconnect.enable = true;

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

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
    enableZshIntegration = true;
    defaultCacheTtl = 28800; # 8 hours
    maxCacheTtl = 86400; # 24 hours
  };

}
