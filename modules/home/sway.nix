{
  pkgs,
  lib,
  ...
}:

{
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
    systemd.xdgAutostart = true;
    checkConfig = false;

    extraConfigEarly = ''
      # User Variables
      set $mod Mod4
      set $left h
      set $down j
      set $up k
      set $right l

      set $term kitty
      set $menu_term kitty
      set $menu "wofi --show=drun --conf /home/dark/.config/wofi/config --style /home/dark/.config/wofi/style.css"
      set $commands "wofi --show=run --conf /home/dark/.config/wofi/config --style /home/dark/.config/wofi/style.css"
      set $browser qutebrowser
      set $explorer thunar
      set $WOBSOCK $XDG_RUNTIME_DIR/wob.sock
      set $disp1 eDP-1
      set $disp2 DP-2
    '';

    config = {
      modifier = "Mod4";
      left = "h";
      down = "j";
      up = "k";
      right = "l";

      terminal = "kitty";

      output = {
        "eDP-1" = {
          scale = "1.5";
        };
        "DP-2" = {
          scale = "1.5";
        };
        "DP-1" = {
          scale = "1.5";
        };
      };

      input = {
        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
        };
      };

      workspaceOutputAssign = [
        {
          workspace = "1";
          output = "eDP-1";
        }
        {
          workspace = "2";
          output = "eDP-1";
        }
        {
          workspace = "3";
          output = "eDP-1";
        }
        {
          workspace = "4";
          output = "eDP-1";
        }
      ];

      focus = {
        followMouse = "no";
        mouseWarping = "container";
        wrapping = "no";
      };

      bars = [ ];

      gaps = {
        inner = 8;
        outer = 8;
      };

      window = {
        titlebar = false;
        border = 3;
        commands = [
          {
            command = "title_format \"%title [XWayland]\"";
            criteria = {
              shell = "xwayland";
            };
          }
          {
            command = "inhibit_idle fullscreen";
            criteria = {
              app_id = "firefox";
            };
          }
          {
            command = "inhibit_idle fullscreen";
            criteria = {
              app_id = "floorp";
            };
          }
          {
            command = "inhibit_idle focus";
            criteria = {
              app_id = "zen";
            };
          }
          {
            command = "inhibit_idle fullscreen";
            criteria = {
              app_id = "mpv";
            };
          }
          {
            command = "floating enable, resize set 720 480";
            criteria = {
              app_id = "pavucontrol";
            };
          }
          {
            command = "floating enable, move scratchpad, focus_on_window_activation none";
            criteria = {
              class = "PenTablet";
            };
          }
          {
            command = "border none";
            criteria = {
              app_id = "SwayNotificationCenter";
            };
          }
          {
            command = "border none";
            criteria = {
              app_id = "swaync";
            };
          }
        ];
      };

      floating = {
        modifier = "$mod normal";
        criteria = [
          { window_role = "pop-up"; }
          { window_role = "bubble"; }
          { window_role = "dialog"; }
          { window_type = "dialog"; }
          { title = "Picture-in-Picture"; }
        ];
      };

      startup = [
        {
          command = "systemctl --user import-environment WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP && systemctl --user start sway-session.target";
        }
        { command = "dex -a -e sway"; }
        { command = "swaymsg \"workspace 2; exec $term\""; }
        { command = "swaymsg \"workspace 1; exec $term\""; }
        {
          command = "rm -f $WOBSOCK && mkfifo $WOBSOCK && tail -f $WOBSOCK | wob -c $HOME/.cache/wallust/wob.ini";
        }
      ];

      keybindings = {
        "$mod+Return" = "exec $term";
        "Alt+Space" = "exec $menu";
        "$mod+Slash" = "exec $commands";
        "$mod+Alt+t" = "exec kitten quick-access-terminal";
        "XF86Assistant" = "exec kitten quick-access-terminal";

        "$mod+Shift+q" = "kill";
        "$mod+Shift+c" = "reload";
        "$mod+Shift+Escape" =
          "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";

        "$mod+$left" = "focus left";
        "$mod+$down" = "focus down";
        "$mod+$up" = "focus up";
        "$mod+$right" = "focus right";

        "$mod+Shift+$left" = "move left";
        "$mod+Shift+$down" = "move down";
        "$mod+Shift+$up" = "move up";
        "$mod+Shift+$right" = "move right";

        "$mod+Control+Shift+$left" = "move container to workspace prev";
        "$mod+Control+Shift+$right" = "move container to workspace next";

        "$mod+1" = "workspace number 1";
        "$mod+2" = "workspace number 2";
        "$mod+3" = "workspace number 3";
        "$mod+4" = "workspace number 4";
        "$mod+5" = "workspace number 5";
        "$mod+6" = "workspace number 6";
        "$mod+7" = "workspace number 7";
        "$mod+8" = "workspace number 8";
        "$mod+9" = "workspace number 9";
        "$mod+0" = "workspace number 10";

        "$mod+Shift+1" = "move container to workspace number 1";
        "$mod+Shift+2" = "move container to workspace number 2";
        "$mod+Shift+3" = "move container to workspace number 3";
        "$mod+Shift+4" = "move container to workspace number 4";
        "$mod+Shift+5" = "move container to workspace number 5";
        "$mod+Shift+6" = "move container to workspace number 6";
        "$mod+Shift+7" = "move container to workspace number 7";
        "$mod+Shift+8" = "move container to workspace number 8";
        "$mod+Shift+9" = "move container to workspace number 9";
        "$mod+Shift+0" = "move container to workspace number 10";

        "$mod+b" = "splith";
        "$mod+v" = "splitv";
        "$mod+s" = "layout stacking";
        "$mod+w" = "layout tabbed";
        "$mod+e" = "layout toggle split";
        "$mod+f" = "fullscreen";

        "$mod+Shift+space" = "floating toggle";
        "$mod+space" = "focus mode_toggle";
        "$mod+a" = "focus parent";
        "$mod+d" = "focus child";

        "$mod+Shift+minus" = "move scratchpad";
        "$mod+minus" = "scratchpad show";
        "$mod+r" = "mode \"resize\"";

        "XF86AudioRaiseVolume" =
          "exec pactl set-sink-volume @DEFAULT_SINK@ +5% && pactl get-sink-volume @DEFAULT_SINK@ | awk 'NR==1{print substr($5,1,length($5)-1)}' > $WOBSOCK";
        "XF86AudioLowerVolume" =
          "exec pactl set-sink-volume @DEFAULT_SINK@ -5% && pactl get-sink-volume @DEFAULT_SINK@ | awk 'NR==1{print substr($5,1,length($5)-1)}' > $WOBSOCK";
        "XF86AudioMute" =
          "exec pactl set-sink-mute @DEFAULT_SINK@ toggle && ( [ \"$(pactl get-sink-mute @DEFAULT_SINK@)\" = \"Mute: yes\" ] && echo 0 > $WOBSOCK ) || pactl get-sink-volume @DEFAULT_SINK@ | awk 'NR==1{print substr($5,1,length($5)-1)}' > $WOBSOCK";
        "--locked XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

        "--locked XF86MonBrightnessDown" =
          "exec brightnessctl set 5%- | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > $WOBSOCK";
        "--locked XF86MonBrightnessUp" =
          "exec brightnessctl set +5% | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > $WOBSOCK";

        "Print" = "exec screenshot full";
        "$mod+Shift+s" = "exec screenshot partial";
        "$mod+Shift+v" = "exec cliphist list | wofi --dmenu | cliphist decode | wl-copy";
        "$mod+Shift+n" = "exec swaync-client -t -sw";

        "--locked $mod+Control+b" = "exec $menu_term --app-id \"user-dialog\" bluetui";
        "--locked $mod+Control+m" = "exec $menu_term --app-id \"user-dialog\" nmtui";

        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioPause" = "exec playerctl play-pause";
        "$mod+Control+k" = "exec opacity_control";
        "$mod+p" = "exec mirror";
        "$mod+Shift+e" = "exec wofi-emoji";
        "$mod+Alt+p" = "exec wallpaper";
        "$mod+Alt+n" = "exec note";
        "$mod+Control+l" =
          "exec swaylock -f -C ~/.cache/wallust/swaylock-config 2>/dev/null || swaylock -f";
        "$mod+Alt+w" = "exec $browser";
        "$mod+Alt+e" = "exec $explorer";
      };

      modes = {
        resize = {
          "$left" = "resize shrink width 10px";
          "$down" = "resize grow height 10px";
          "$up" = "resize shrink height 10px";
          "$right" = "resize grow width 10px";
          "Left" = "resize shrink width 10px";
          "Down" = "resize grow height 10px";
          "Up" = "resize shrink height 10px";
          "Right" = "resize grow width 10px";
          "Return" = "mode \"default\"";
          "Escape" = "mode \"default\"";
        };
      };
    };

    extraConfig = ''
      # SwayFX Special Effects
      blur enable
      corner_radius 10
      shadows enable
      default_dim_inactive 0.1
      titlebar_separator enable

      for_window [floating] dim_inactive 0

      layer_effects "kitty-quick-access" {
          blur enable
          blur_ignore_transparent enable
          corner_radius 10
      }

      layer_effects "swaync-control-center" {
          blur enable
          blur_xray enable
          blur_ignore_transparent enable
          shadows disable
          corner_radius 10
      }

      layer_effects "swaync-notification-window" {
          blur disable
      }

      layer_effects "gtk-layer-shell" {
          blur enable
          blur_xray enable
          blur_ignore_transparent enable
          shadows disable
          corner_radius 10
      }

      include ~/.cache/wallust/colors-sway

      set $bg-color            $background
      set $text-color          $foreground
      set $inactive-bg-color   $color0
      set $inactive-text       $color7
      set $urgent-bg-color     $color1
      set $urgent-text         $foreground
      set $border-color        $color4
      set $indicator           $color6

      client.focused           $border-color   $bg-color          $text-color     $indicator    $border-color
      client.focused_inactive  $color0         $color0            $inactive-text  $indicator    $color0
      client.unfocused         $color0         $color0            $inactive-text  $indicator    $color0
      client.urgent            $urgent-bg-color $urgent-bg-color  $urgent-text    $indicator    $urgent-bg-color
    '';
  };
}
