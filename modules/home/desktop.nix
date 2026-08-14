{
  config,
  pkgs,
  self,
  ...
}:

let
  wallpaperScript = pkgs.writeShellApplication {
    name = "wallpaper";
    runtimeInputs = with pkgs; [
      wallust
      awww
      wofi
      imagemagick
      sway
      swaynotificationcenter
      procps
      findutils
      gnugrep
    ];
    text = builtins.readFile ../../scripts/wallpaper;
  };

  screenshotScript = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = with pkgs; [
      grim
      slurp
      wl-clipboard
      libnotify
      (tesseract.override { enableLanguages = [ "eng" ]; })
      imagemagick
      kitty
      xdg-utils
    ];
    text = builtins.readFile ../../scripts/screenshot;
  };

  wofiEmojiScript = pkgs.writeScriptBin "wofi-emoji" ''
    #!${pkgs.bash}/bin/bash
    PATH="${
      pkgs.lib.makeBinPath (
        with pkgs;
        [
          wofi
          wtype
          wl-clipboard
          coreutils
          gnused
        ]
      )
    }:$PATH"
    export PATH
    ${builtins.readFile ../../scripts/wofi-emoji}
  '';

  mirrorScript = pkgs.writeShellApplication {
    name = "mirror";
    runtimeInputs = with pkgs; [
      wofi
      wl-mirror
      gnugrep
      coreutils
    ];
    text = builtins.readFile ../../scripts/mirror;
  };

  noteScript = pkgs.writeShellApplication {
    name = "note";
    runtimeInputs = with pkgs; [
      wofi
      neovim
      kitty
    ];
    text = builtins.readFile ../../scripts/note;
  };
in
{
  home.packages = [
    wallpaperScript
    screenshotScript
    wofiEmojiScript
    mirrorScript
    noteScript
  ];

  home.pointerCursor = {
    name = "Vimix-cursors";
    enable = true;
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
    platformTheme.name = "kde";
    style = {
      name = "breeze";
      package = pkgs.kdePackages.breeze;
    };
    kde.settings = {
      kdeglobals = {
        General = {
          ColorScheme = "BreezeDark";
          name = "BreezeDark";
        };
        KDE = {
          LookAndFeelPackage = "org.kde.breezedark.desktop";
        };
      };
    };
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  xdg.configFile = {
    "waybar".source = config.lib.file.mkOutOfStoreSymlink "${self}/waybar";
    "wofi".source = config.lib.file.mkOutOfStoreSymlink "${self}/wofi";
    "swaync".source = config.lib.file.mkOutOfStoreSymlink "${self}/swaync";
    "swaylock".source = config.lib.file.mkOutOfStoreSymlink "${self}/swaylock";
    "wallust".source = config.lib.file.mkOutOfStoreSymlink "${self}/wallust";
    "wob".source = config.lib.file.mkOutOfStoreSymlink "${self}/wob";
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${self}/nvim";
    "qutebrowser".source = config.lib.file.mkOutOfStoreSymlink "${self}/qutebrowser";
  };

  # home.file.".local/bin" = {
  #   source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/scripts";
  #   recursive = true;
  # };
}
