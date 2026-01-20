{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    ########################################
    # STRUCTURED SETTINGS (SAFE PART)
    ########################################
    settings = {

      ############################
      # ENVIRONMENT
      ############################
      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "WLR_NO_HARDWARE_CURSORS,1"
        "LIBVA_DRIVER_NAME,iHD"
        "MOZ_ENABLE_WAYLAND,2"
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
        active_opacity   = 1.0;
        inactive_opacity = 0.8;

        blur.enabled   = false;
        shadow.enabled = false;
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
      # LAYOUT
      ############################
      dwindle = {
        preserve_split = true;
        force_split = 2;
      };

      ############################
      # MONITOR
      ############################
      monitor = [
        "eDP-1,preferred,auto,1"
      ];

      ############################
      # GLOBAL KEYBINDS
      ############################
      bind = [
        "SUPER, RETURN, exec, $terminal"
        "SUPER, B, exec, $browser"
        "SUPER, F, exec, $fileManager"
        "SUPER, D, exec, $menu"

        "SUPER, C, killactive"
        "SUPER SHIFT, Q, exit"
        "SUPER, V, togglefloating"

        # 🔐 GLOBAL ESC — ALWAYS SAFE
        ", Escape, submap, reset"

        # focus
        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"

        # resize entry
        "SUPER, R, submap, resize"

        # system
        "CTRL ALT, RETURN, exec, systemctl poweroff"
        "CTRL ALT, DELETE, exec, systemctl reboot"
      ];

      ############################
      # MEDIA KEYS
      ############################
      bindel = [
        ",XF86MonBrightnessUp, exec, brightnessctl set +10%"
        ",XF86MonBrightnessDown, exec, brightnessctl set 10%-"
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];

      ############################
      # AUTOSTART
      ############################
      exec-once = [
        "hyprpaper"
        "nm-applet"
        "blueman-applet"
        "systemctl --user restart wireplumber"
        "swww-daemon"
      ];
    };

    ########################################
    # RAW HYPRLAND DSL (REQUIRED FOR SUBMAP)
    ########################################
    extraConfig = ''
      submap = resize
      bind = SUPER, left,  resizeactive, -20 0
      bind = SUPER, right, resizeactive, 20 0
      bind = SUPER, up,    resizeactive, 0 -20
      bind = SUPER, down,  resizeactive, 0 20
      bind = , Escape, submap, reset
      submap = reset
    '';
  };
}

