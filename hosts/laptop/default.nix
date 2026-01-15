{ config, pkgs, ... }:

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

  system.stateVersion = "25.11";
}

