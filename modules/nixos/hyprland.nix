{ config, pkgs, lib, ... }:

{
  services.xserver.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.displayManager.defaultSession = "hyprland-uwsm";

  services.displayManager.autoLogin = {
    enable = true;
    user = "avto";
  };

  environment.systemPackages = with pkgs; [
    bibata-cursors
  ];
}

