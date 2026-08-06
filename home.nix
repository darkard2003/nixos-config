{ config, pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";


  home.packages = with pkgs; [
    btop
    ripgrep
    tmux
    git
    kitty
    grim
    slurp
    wl-clipboard
  ];

  wayland.windowManager.sway = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "kitty";
        menu = "wofi --show drun";

        bars = [
          { command = "waybar"; }
        ];
      };
    };

  programs.waybar = {
    enable = true;
  };

  programs.wofi = {
    enable = true;
  };

  programs.kitty = {
      enable = true;
      settings = {
        confirm_os_window_close = 0;
        background_opacity = "0.95";
      };
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "darkard2003";
      email="kaushikchowdhury231@gmail.com";
    };
    extraConfig.init.defaultBranch = "main";
  };

  programs.home-manager.enable = true;

  home.stateVersion = "26.05";
}
