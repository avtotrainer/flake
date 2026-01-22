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

  # WSL თავად მართავს ქსელს
  networking.networkmanager.enable = lib.mkForce false;
  services.dhcpcd.enable = lib.mkForce false;

  # systemd user/session არ უნდა რესტარტდეს
  services.getty.autologinUser = lib.mkForce null;
  systemd.services."user@".enable = false;

  # power / time irrelevant WSL-ში
  services.timesyncd.enable = false;
  services.upower.enable = false;

  # ----------------------------
  # Minimal CLI (WSL bootstrap)
  # ----------------------------
  environment.systemPackages = with pkgs; [
    git        # აუცილებელი: repo clone / update
    tmux       # სესიის კონტროლი
    neovim     # მინიმალური რედაქტორი
  ];

  system.stateVersion = "25.11";
}

