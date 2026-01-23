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
  wsl.enable = true;
  wsl.defaultUser = "avto";

  # ----------------------------------------
  # Override laptop-only TTY autologin from base.nix
  # (WSL-ში getty არ გვჭირდება)
  # ----------------------------------------
  services.getty.autologinUser = lib.mkForce null;

  # ----------------------------------------
  # Password: Repo-დან გადაწყდეს, WSL-ზე კი sudo იმუშაოს
  # (დროებითი, სწრაფი გზა)
  # ----------------------------------------
  users.mutableUsers = true;
  users.users.avto.initialPassword = "2";

  # ----------------------------------------
  # direnv + nix-direnv (system-level)
  # ----------------------------------------
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # ----------------------------------------
  # Minimal CLI + Neovim deps (system-level)
  # ----------------------------------------
  environment.systemPackages = with pkgs; [
    git
    tmux
    neovim

    # NvChad practical deps
    ripgrep
    fd
    gcc
    gnumake
    unzip
    nodejs
    python3
  ];

  system.stateVersion = "25.11";
}

