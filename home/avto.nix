{ config, pkgs, osConfig, ... }:

{
  home.username = "avto";
  home.homeDirectory = "/home/avto";

  # --- IMPORTANT ---
  # Allow Home Manager to take over existing ~/.config files safely
  home-manager.backupFileExtension = "bak";

  # --- Session / Environment ---
  home.sessionVariables = {
    HOSTNAME_FROM_FLAKE = osConfig.networking.hostName;
    EDITOR = "nvim";
    VISUAL = "nvim";
    NVIM_APPNAME = "nvim";
  };

  # --- Imports ---
  imports = [
    ./zsh/zsh.nix
    ./config/config.nix
  ];

  # --- User packages (UI + tools) ---
  home.packages = with pkgs; [
    git
    neovim
    waybar
  ];

  # --- Git ---
  programs.git = {
    enable = true;
    settings.user = {
      name = "avto";
      email = "avto@example.com";
    };
  };

  # --- REQUIRED ---
  home.stateVersion = "25.11";
}
