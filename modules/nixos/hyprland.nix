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
  # CURSOR (SYSTEM-WIDE)
  #############################################
  environment.systemPackages = with pkgs; [
    bibata-cursors
  ];

  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };

  #############################################
  # HYPRLAND CONFIG (SYSTEM LAYER)
  #############################################
  environment.etc."xdg/hypr/hyprland.conf".text = ''
    #############################################
    # HYPRLAND CONFIG — FINAL / STABLE
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
    # GENERAL (PIXMAN-SAFE)
    #############################################
    general {
      gaps_in = 4
      gaps_out = 8
      border_size = 2

      allow_tearing = true
      extend_border_grab_area = 0
      hover_icon_on_border = true
    }

    #############################################
    # DECORATION (PIXMAN-SAFE)
    #############################################
    decoration {
      rounding = 8

      blur {
        enabled = false
      }

      shadow {
        enabled = false
      }

      active_opacity = 1.0
      inactive_opacity = 1.0
    }

    #############################################
    # ANIMATIONS
    #############################################
    animations {
      enabled = yes
      animation = windows,   1, 5, default
      animation = fade,      1, 3, default
      animation = global,    1, 7, default
      animation = windowsIn, 1, 6

