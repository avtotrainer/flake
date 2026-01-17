{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix

    ../../modules/nixos/base.nix
    ../../modules/nixos/boot-silent.nix
    ../../modules/nixos/power.nix
    ../../modules/nixos/bluetooth.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/graphics-intel.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/hyprland.nix
    ../../modules/nixos/ssh.nix
    ../../modules/nixos/locale.nix

    ../../profiles/nixos/laptop.nix
    ../../profiles/nixos/dev.nix

    ../../users/avto.nix
  ];

  networking.hostName = "nixos";

  # ------------------------------------------------------------
  # BOOT SAFETY (Live USB აღარ დაგჭირდეს)
  #
  # 1) Generations მეტიც იყოს, არა მხოლოდ ბოლო
  # 2) Boot menu გამოჩნდეს რამდენიმე წამით
  # ------------------------------------------------------------
  boot.loader.systemd-boot.configurationLimit = lib.mkForce 20;
  boot.loader.timeout = lib.mkForce 3;

  # ------------------------------------------------------------
  # SAFE SPECIALISATION
  #
  # Boot menu-ში გაჩნდება დამატებითი ვარიანტი: "SAFE"
  # რომელიც გამორთავს autostart-ს (Hyprland/Waybar),
  # რომ ნებისმიერ დროს შეძლო TTY-ზე სტაბილურად ჩატვირთვა.
  # ------------------------------------------------------------
  specialisation.safe.configuration = {
    systemd.user.services.hyprland-autostart = {
      Install.WantedBy = lib.mkForce [ ];
    };

    systemd.user.services.waybar = {
      Install.WantedBy = lib.mkForce [ ];
    };
  };

  system.stateVersion = "25.11";
}

