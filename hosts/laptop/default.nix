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

    ../../users/users.nix
  ];

  networking.hostName = "nixos";

  # ─────────────────────────────────────────────
  # Networking — LAPTOP RESPONSIBILITY
  # ─────────────────────────────────────────────
  networking.networkmanager.enable = true;

  # როცა NetworkManager გვაქვს, dhcpcd არ გვინდა
  networking.useDHCP = false;

  # ─────────────────────────────────────────────
  # Boot behaviour
  # ─────────────────────────────────────────────
  boot.loader.systemd-boot.configurationLimit = lib.mkForce 20;
  boot.loader.timeout = lib.mkForce 3;

  # ─────────────────────────────────────────────
  # System packages
  # ─────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    python312
    python314
    direnv
    gnumake
  ];

  system.stateVersion = "25.11";
}

