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

  networking.networkmanager.enable = lib.mkForce false;
  services.upower.enable = lib.mkForce false;
  services.getty.autologinUser = lib.mkForce null;

  environment.systemPackages = with pkgs; [
    tmux
    neovim
  ];

  system.stateVersion = "25.11";
}

