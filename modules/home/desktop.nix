{
  config,
  lib,
  pkgs,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos-config/dotfiles";

  wallpaperScript = pkgs.writeShellApplication {
    name = "wallpaper";
    runtimeInputs = with pkgs; [
      wallust
      awww
      wofi
      imagemagick
      sway
      swaynotificationcenter
      systemd
      procps
      findutils
      gnugrep
      coreutils
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
      handlr-regex
      xdg-user-dirs
      coreutils
    ];
    text = builtins.readFile ../../scripts/screenshot;
  };

  wofiEmojiScript = pkgs.writeShellApplication {
    name = "wofi-emoji";
    runtimeInputs = with pkgs; [
      wofi
      wtype
      wl-clipboard
      coreutils
      gnused
    ];
    checkPhase = "";
    text = builtins.readFile ../../scripts/wofi-emoji;
  };

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
      libnotify
      findutils
      gnugrep
      gnused
      coreutils
    ];
    text = builtins.readFile ../../scripts/note;
  };

  wobRunnerScript = pkgs.writeShellApplication {
    name = "wob-runner";
    runtimeInputs = with pkgs; [
      wob
      coreutils
    ];
    text = builtins.readFile ../../scripts/wob-runner;
  };
in
{
  home.packages = [
    wallpaperScript
    screenshotScript
    wofiEmojiScript
    mirrorScript
    noteScript
    wobRunnerScript
  ];

  systemd.user.services.wob = {
    Unit = {
      Description = "Wayland Overlay Bar (wob)";
      PartOf = [ "sway-session.target" ];
      After = [ "sway-session.target" ];
    };
    Service = {
      ExecStart = "${wobRunnerScript}/bin/wob-runner";
      Restart = "on-failure";
      RestartSec = 1;
    };
    Install = {
      WantedBy = [ "sway-session.target" ];
    };
  };

  home.activation.seedWallustTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "$HOME/.cache/wallust/colors-sway" ] || [ ! -f "$HOME/.cache/wallust/lockscreen_blur.png" ]; then
      $DRY_RUN_CMD ${wallpaperScript}/bin/wallpaper "${config.home.homeDirectory}/nixos-config/wallpapers/cowboy-blue.jpg" || true
    fi
  '';

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
    platformTheme.name = "qt6ct";
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
    "waybar".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/waybar";
    "wofi".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/wofi";
    "swaync".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/swaync";
    "swaylock".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/swaylock";
    "wallust".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/wallust";
    "wob".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/wob";
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";
  };
}
