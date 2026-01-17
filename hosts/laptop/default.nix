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

  # მეტი generation + boot menu timeout
  boot.loader.systemd-boot.configurationLimit = lib.mkForce 20;
  boot.loader.timeout = lib.mkForce 3;

  # SAFE boot entry: Hyprland/Waybar autostart გამორთული
  specialisation.safe.configuration = {
    systemd.user.services.hyprland-autostart.wantedBy = lib.mkForce [ ];
    systemd.user.services.waybar.wantedBy = lib.mkForce [ ];
  };

  system.stateVersion = "25.11";
}

