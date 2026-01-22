{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix

    ../../modules/nixos/base.nix
    ../../modules/nixos/locale.nix

    ../../users/users.nix
    ../../users/avto.nix
  ];

  networking.hostName = "wsl";

  # ----------------------------
  # WSL SAFETY
  # ----------------------------

  # WSL-ში ქსელს მართავს Windows
  networking.networkmanager.enable = lib.mkForce false;
  networking.useDHCP = lib.mkForce false;

  # არ ვცდილობთ user session / autologin-ს
  services.getty.autologinUser = lib.mkForce null;

  # დრო და power არ არის აქტუალური WSL-ში
  services.timesyncd.enable = false;
  services.upower.enable = false;

  # ----------------------------
  # Minimal CLI (WSL bootstrap)
  # ----------------------------
  environment.systemPackages = with pkgs; [
    git
    tmux
    neovim
  ];

  system.stateVersion = "25.11";
}

