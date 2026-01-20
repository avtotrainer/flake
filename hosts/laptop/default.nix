{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
    ./wallpaper.nix
    
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

  environment.systemPackages = with pkgs; [
    python312
    python314
    direnv
    gnumake
  ];


  system.stateVersion = "25.11";
}

