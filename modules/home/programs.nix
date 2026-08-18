{
  pkgs,
  ...
}:

{
  programs.imv.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
    ];
  };

  programs.neovim = {
    enable = true;
    sideloadInitLua = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      gcc
      gnumake
      unzip

      ripgrep
      fd
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    silent = true;
    mise.enable = true;
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "darkard2003";
        email = "kaushikchowdhury231@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [ batman ];
  };

  programs.btop = {
    enable = true;
  };

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      targets = [ "sway-session.target" ];
    };
  };

  systemd.user.services.waybar = {
    Unit = {
      Before = [ "tray.target" ];
    };
    Service = {
      Type = "dbus";
      BusName = "fr.arouillard.waybar";
    };
  };

  xdg.configFile."systemd/user/app-@autostart.service.d/order.conf".text = ''
    [Unit]
    After=tray.target waybar.service
    Wants=tray.target
  '';

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 14;
    };
    settings = {
      foreground = "#cdd6f4";
      background = "#1e1e2e";
      selection_foreground = "#1e1e2e";
      selection_background = "#f5e0dc";
      background_opacity = "0.85";
      background_blur = 20;
      background_tint = "0.35";
      bold_is_bright = true;
      allow_remote_control = "yes";
    };
    quickAccessTerminalConfig = {
      background_opacity = 0.85;
      margin_left = 10;
      margin_right = 10;
      margin_top = 10;
      margin_bottom = 10;

      lines = 15;
    };
    extraConfig = ''
      include ~/.cache/wallust/colors-kitty.conf
    '';
  };

  programs.nix-index = {
    enable = true;
  };

  programs.nix-index-database.comma.enable = true;

  programs.lazygit.enable = true;

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    mouse = true;
    sensibleOnTop = true;
    shortcut = "a";
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      yank
      resurrect
      continuum
    ];

    extraConfig = ''
      bind b split-window -h -c "#{pane_current_path}"
      bind v split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Easy reload of tmux config
      bind r source-file ~/.config/tmux/tmux.conf 

      # Vim movementr
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      set -g allow-rename off

      set-option -g status-position top
      set -g renumber-windows on

      # set extended key
      set -g extended-keys on
      set -g extended-keys-format csi-u

      # Faster pane resizing
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Wallust dynamic colors
      if-shell '[ -f ~/.cache/wallust/colors-tmux.conf ]' 'source-file ~/.cache/wallust/colors-tmux.conf'

      # Kitty image protocol
      set -gq allow-passthrough on
      set -g visual-activity off

      # Vim mode copy
      bind Space copy-mode
      setw -g mode-keys vi
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi V send-keys -X select-line
      bind-key -T copy-mode-vi Y send-keys -X select-line
      bind g display-popup -d '#{pane_current_path}' -w 80% -h 80% -E 'lazygit'
    '';

  };

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      mpris
      uosc # Modern minimalist UI
      thumbfast # Video timeline preview thumbnails
      autosubsync-mpv # Automatic subtitle timing synchronization
      sponsorblock # Auto-skip sponsors via yt-dlp
      quality-menu # On-the-fly resolution switcher
    ];

    config = {
      # Video Quality & Smooth Motion
      profile = "high-quality";
      hwdec = "auto-safe";
      video-sync = "display-resample";
      interpolation = true;

      # Window & Playback Behavior
      keep-open = "yes";
      save-position-on-quit = true;
      autofit = "70%";

      # Language Priorities & Subtitles
      alang = "eng,en,jpn,ja";
      slang = "eng,en";
      sub-auto = "fuzzy";
      audio-file-auto = "fuzzy";
      sub-font-size = 46;
      sub-border-size = 2.5;
      sub-shadow-offset = 1;

      # UI Integration for uosc
      osc = false;
      osd-bar = false;

      # Streaming & Screenshots
      ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";
      screenshot-directory = "~/Pictures/mpv";
    };
    bindings = {
      WHEEL_UP = "add volume 2";
      WHEEL_DOWN = "add volume -2";
      "Shift+g" = "add sub-scale +0.1";
      "Shift+f" = "add sub-scale -0.1";
    };
  };

  programs.home-manager.enable = true;
}
