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

  # ----------------------------------------
  # WSL CORE
  # ----------------------------------------

  # ⚠️ კრიტიკული: ვუთხრათ WSL-ს ვინ არის default user
  wsl.enable = true;
  wsl.defaultUser = "avto";

  # ----------------------------------------
  # WSL SAFETY
  # ----------------------------------------

  networking.networkmanager.enable = lib.mkForce false;
  networking.useDHCP = lib.mkForce false;

  services.getty.autologinUser = lib.mkForce null;
  services.timesyncd.enable = false;
  services.upower.enable = false;

  # ----------------------------------------
  # Minimal CLI
  # ----------------------------------------
  environment.systemPackages = with pkgs; [
    git
    tmux
    neovim
  ];

  system.stateVersion = "25.11";
}

