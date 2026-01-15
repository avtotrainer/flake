{ config, pkgs, ... }:

{
  ############################
  # Basic Home Manager setup #
  ############################

  home.username = "avto";
  home.homeDirectory = "/home/avto";
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  ################
  # XDG          #
  ################

  xdg.enable = true;

  ################
  # Packages     #
  ################

  home.packages = with pkgs; [
    swww
    grim
    slurp
  ];

  ################
  # Hyprland     #
  ################

  home.file.".config/hypr/hyprland.conf" = {
    source = ./hypr/hyprland.conf;
  };

  ################
  # Wallpaper    #
  ################

  home.file.".config/hypr/wallpaper.sh" = {
    source = ./hypr/wallpaper.sh;
    executable = true;
  };

  systemd.user.services.wallpaper = {
    Unit = {
      Description = "Wallpaper setter";
      PartOf = [ "hyprland-session.target" ];
      After  = [ "hyprland-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "%h/.config/hypr/wallpaper.sh";
    };

    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };

  ################
  # Waybar       #
  ################

  programs.waybar.enable = true;

  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar";
      PartOf = [ "hyprland-session.target" ];
      After  = [ "hyprland-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
      RestartSec = 2;
    };

    Install = {
      WantedBy = [ "hyprland-session.target" ];
    };
  };
}

