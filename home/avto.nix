{ pkgs, osConfig, ... }:

{
  # --- Identity ---
  home.username = "avto";
  home.homeDirectory = "/home/avto";

  # --- One-time adoption safety ---
  # Existing ~/.config files will be renamed to *.bak
  home-manager.backupFileExtension = "bak";

  # --- Session / Environment ---
  home.sessionVariables = {
    HOSTNAME_FROM_FLAKE = osConfig.networking.hostName;
    EDITOR = "nvim";
    VISUAL = "nvim";
    NVIM_APPNAME = "nvim";
  };

  # --- Modular config imports ---
  imports = [
    ./zsh/zsh.nix
    ./config/config.nix
  ];

  # --- User-scoped packages (UI & tools) ---
  home.packages = with pkgs; [
    git
    neovim
    waybar
  ];

  # --- Git configuration ---
  programs.git = {
    enable = true;
    settings.user = {
      name = "avto";
      email = "avto@example.com";
    };
  };

  # --- REQUIRED: do not change after first switch ---
  home.stateVersion = "25.11";
}
