{ config, pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
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
    extraConfig = ''
      include ~/.cache/wallust/colors-kitty.conf
    '';
  };

  programs.home-manager.enable = true;
}
