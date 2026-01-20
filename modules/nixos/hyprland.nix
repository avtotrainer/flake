{ config, pkgs, lib, ... }:

{
  #############################################
  # X / DISPLAY MANAGER
  #############################################
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.displayManager.defaultSession = "hyprland-uwsm";

  services.displayManager.autoLogin = {
    enable = true;
    user = "avto";
  };

  #############################################
  # HYPRLAND
  #############################################
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  #############################################
  # CURSOR (SYSTEM-WIDE, CLEAN)
  #############################################
  environment.systemPackages = with pkgs; [
    bibata-cursors
  ];

  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };

  #############################################
  # HYPRLAND CONFIG (SYSTEM LAYER — FINAL)
  #############################################
  environment.etc."xdg/hypr/hyprland.conf".text = ''
    #############################################
    # HYPRLAND CONFIG — FINAL MERGED VERSION
    #############################################

    ### ENVIRONMENT
    env = XDG_CURRENT_DESKTOP,Hyprland
    env = WLR_NO_HARDWARE_CURSORS,1
    env = LIBVA_DRIVER_NAME,iHD
    env = MOZ_ENABLE_WAYLAND,1
    env = QT_QPA_PLATFORM,wayland
    env = GDK_BACKEND,wayland

    #############################################
    # APPLICATION VARIABLES
    #############################################
    $terminal = alacritty
    $browser = google-chrome-stable
    $fileManager = thunar
    $menu = wofi --show drun

    #############################################
    # INPUT
    #############################################
    input {
      kb_layout = us,ge
      kb_variant = ,ergonomic
      kb_options = grp:win_space_toggle

      follow_mouse = 1
      repeat_delay = 300
      repeat_rate  = 35

      touchpad {
        natural_scroll = true
        tap-to-click = true
        scroll_factor = 0.8
      }
    }

    #############################################
    # GENERAL
    #############################################
    general {
      gaps_in = 4
      gaps_out = 8
      border_size = 2
      allow_tearing = false
      hover_icon_on_border = true
      extend_border_grab_area = 15
    }

    #############################################
    # DECORATION
    #############################################
    decoration {
      rounding = 8
      blur { enabled = false }
      shadow { enabled = false }
      active_opacity = 1.0
      inactive_opacity = 0.8
    }

    #############################################
    # ANIMATIONS
    #############################################
    animations {
      enabled = yes
      animation = windows, 1, 5, default
      animation = fade,    1, 3, default
      animation = global,  1, 7, default
      animation = windowsIn, 1, 6, default, popin
      animation = fadeIn, 1, 6, default
      animation = fadeOut, 1, 6, default
    }

    #############################################
    # LAYOUT
    #############################################
    dwindle {
      preserve_split = true
      force_split = 2
    }

    #############################################
    # MONITOR
    #############################################
    monitor = eDP-1,preferred,auto,1

    #############################################
    # BINDS — UNTOUCHED
    #############################################
    bind = SUPER, RETURN, exec, $terminal
    bind = SUPER, B, exec, $browser
    bind = SUPER, F, exec, $fileManager

    bind = SUPER, C, killactive
    bind = SUPER SHIFT, Q, exit
    bind = SUPER, V, togglefloating

    bind = SUPER, H, movefocus, l
    bind = SUPER, L, movefocus, r
    bind = SUPER, K, movefocus, u
    bind = SUPER, J, movefocus, d

    bind = SUPER, R, exec, $menu

    #############################################
    # RESIZE MODE (SAFE)
    #############################################
    bind = SUPER SHIFT, R, submap, resize

    submap = resize
      bind = , left,  resizeactive, -20 0
      bind = , right, resizeactive, 20 0
      bind = , up,    resizeactive, 0 -20
      bind = , down,  resizeactive, 0 20
      bind = , escape, submap, reset
    submap = reset

    #############################################
    # AUTOSTART
    #############################################
    exec-once = hyprpaper
    exec-once = nm-applet
    exec-once = blueman-applet
    exec-once = systemctl --user restart wireplumber

    exec-once = hyprctl dispatch exec "[workspace 2 silent"] $terminal
    exec-once = hyprctl dispatch exec "[workspace 1"] $browser
  '';
}

