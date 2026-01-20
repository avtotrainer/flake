{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {

      ############################
      # ENVIRONMENT
      ############################
      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "WLR_NO_HARDWARE_CURSORS,1"
        "LIBVA_DRIVER_NAME,iHD"
        "MOZ_ENABLE_WAYLAND,1"
        "QT_QPA_PLATFORM,wayland"
        "GDK_BACKEND,wayland"
      ];

      ############################
      # VARIABLES
      ############################
      "$terminal"    = "alacritty";
      "$browser"     = "google-chrome-stable";
      "$fileManager" = "thunar";
      "$menu"        = "wofi --show drun";

      ############################
      # INPUT
      ############################
      input = {
        kb_layout  = "us,ge";
        kb_variant = ",ergonomic";
        kb_options = "grp:win_space_toggle";

        follow_mouse = 1;
        repeat_delay = 300;
        repeat_rate  = 35;

        touchpad = {
          natural_scroll = true;
          tap-to-click   = true;
          scroll_factor  = 0.8;
        };
      };

      ############################
      # GENERAL
      ############################
      general = {
        gaps_in  = 4;
        gaps_out = 8;
        border_size = 2;
        allow_tearing = false;
        hover_icon_on_border = true;
        extend_border_grab_area = 15;
      };

      ############################
      # DECORATION
      ############################
      decoration = {
        rounding = 8;

        blur = {
          enabled = false;
        };

        shadow = {
          enabled = false;
        };

        active_opacity   = 1.0;
        inactive_opacity = 0.8;
      };

      ############################
      # ANIMATIONS
      ############################
      animations = {
        enabled = true;

        animation = [
          "windows, 1, 5, default"
          "fade, 1, 3, default"
          "global, 1, 7, default"

          "windowsIn, 1, 6, default, popin"
          "fadeIn, 1, 6, default"
          "fadeOut, 1, 6, default"
        ];
      };

      ############################
      # LAYOUTS
      ############################
      dwindle = {
        preserve_split = true;
        force_split = 2;
      };

      ############################
      # GESTURES
      ############################
      gestures = {
        workspace_swipe_invert = false;
      };

      ############################
      # MONITOR
      ############################
      monitor = [
        "eDP-1,preferred,auto,1"
      ];

      ############################
      # KEYBINDS
      ############################
      bind = [
        # App launchers
        "SUPER, RETURN, exec, $terminal"
        "SUPER, B, exec, $browser"
        "SUPER, F, exec, $fileManager"
        "SUPER, D, exec, $menu"

        # Window control
        "SUPER, C, killactive"
        "SUPER SHIFT, Q, exit"
        "SUPER, V, togglefloating"

        # Focus movement (i3-style)
        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"

        # Resize submap (არ ჭამს ჩვეულებრივ ისრებს)
        "SUPER, R, submap, resize"

        # System
        "CTRL ALT, RETURN, exec, systemctl poweroff"
        "CTRL ALT, DELETE, exec, systemctl reboot"

        # Workspaces
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        # Move window to workspace
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"
      ];

      # resize რეჟიმი: მხოლოდ SUPER+ისრები (ჩვეულებრივი ისრები აღარ იჭრება)
      submap = {
        resize = {
          bind = [
            "SUPER, left,  resizeactive, -20 0"
            "SUPER, right, resizeactive, 20 0"
            "SUPER, up,    resizeactive, 0 -20"
            "SUPER, down,  resizeactive, 0 20"
            ", escape, submap, reset"
          ];
        };
      };

      ############################
      # MEDIA KEYS
      ############################
      bindl = [
        ",XF86TouchpadToggle, exec, hyprctl dispatch toggleinput \"ELAN06FA:00 04F3:32B9 Touchpad\""
      ];

      bindel = [
        ",XF86MonBrightnessUp, exec, brightnessctl set +10%"
        ",XF86MonBrightnessDown, exec, brightnessctl set 10%-"
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];

      ############################
      # WINDOW RULES
      ############################
      windowrulev2 = [
        "noanim, class:(obs)"
      ];

      ############################
      # AUTOSTART
      ############################
      exec-once = [
        "hyprpaper"
        "nm-applet"
        "blueman-applet"
        "systemctl --user restart wireplumber"
        "hyprctl dispatch exec \"[workspace 2 silent] $terminal\""
        "hyprctl dispatch exec \"[workspace 1] $browser\""
        "swww-daemon"
      ];
    };
  };
}

