{ config, pkgs, inputs, ... }:

{
  home.pointerCursor = {
    name = "Vimix-cursors";
    package = pkgs.vimix-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Papirus-Dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    checkConfig = false;
    config = null;
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  xdg.configFile = {
    "sway".source = "${inputs.self}/sway";
    "waybar".source = "${inputs.self}/waybar";
    "wofi".source = "${inputs.self}/wofi";
    "kitty".source = "${inputs.self}/kitty";
    "swaync".source = "${inputs.self}/swaync";
    "swaylock".source = "${inputs.self}/swaylock";
    "wallust".source = "${inputs.self}/wallust";
    "nvim".source = "${inputs.self}/nvim";
  };

  home.file = {
    ".local/bin/wallpaper" = {
      source = "${inputs.self}/scripts/wallpaper";
      executable = true;
    };
    ".local/bin/screenshot" = {
      source = "${inputs.self}/scripts/screenshot";
      executable = true;
    };
    ".local/bin/wofi-emoji" = {
      source = "${inputs.self}/scripts/wofi-emoji";
      executable = true;
    };
    ".local/bin/note" = {
      source = "${inputs.self}/scripts/note";
      executable = true;
    };
    ".local/bin/mirror" = {
      source = "${inputs.self}/scripts/mirror";
      executable = true;
    };
  };
}
