{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    ########################################
    # STRUCTURED SETTINGS
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

        follow_mouse = 0;
        repeat_delay = 300;
        repeat_rate  = 35;

        touchpad = {
          natural_scroll = true;
          tap-to-click   = true;
        };
      };

      ############################
      # GENERAL
      ############################
      general = {
        gaps_in  = 4;
        gaps_out = 8;
        border_size = 2;
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
        # Apps
        "SUPER, RETURN, exec, $terminal"
        "SUPER, B, exec, $browser"
        "SUPER, F, exec, $fileManager"
        "SUPER, D, exec, $menu"

        # Window
        "SUPER, C, killactive"
        "SUPER SHIFT, Q, exit"
        "SUPER, V, togglefloating"

        # Focus
        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"

        # Resize mode entry
        "SUPER, R, submap, resize"

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

        # Move window
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

      ############################
      # AUTOSTART
      ############################
      exec-once = [
        "hyprpaper"
        "nm-applet"
        "blueman-applet"
        "swww-daemon"
      ];
    };

    ########################################
    # SUBMAP (ESC ONLY HERE)
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

