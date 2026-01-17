{ config, pkgs, lib, ... }:

{
  ##################################################
  # WAYLAND-ONLY SYSTEM
  ##################################################
  services.xserver.enable = false;

  ##################################################
  # HYPRLAND (compositor)
  ##################################################
  programs.hyprland.enable = true;

  ##################################################
  # DISPLAY MANAGER — SDDM (WAYLAND)
  #
  # მიზეზი:
  # - სრული systemd-logind ინტეგრაცია
  # - graphical-session.target
  # - systemd --user სერვისები (Waybar)
  #
  ##################################################
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Default graphical session
  services.displayManager.defaultSession = "hyprland";

  ##################################################
  # AUTOLOGIN (SDDM-ით, არა TTY)
  #
  # თუ არ გინდა — უბრალოდ წაშალე ეს ბლოკი
  ##################################################
  services.displayManager.autoLogin = {
    enable = true;
    user = "avto";
  };

  ##################################################
  # IMPORTANT GUARANTEE
  #
  # greetd საერთოდ არ არის ნახსენები.
  # არც enable=true, არც enable=false.
  # ეს ნიშნავს: greetd ფიზიკურად ვერ ჩაირთვება.
  ##################################################
}

