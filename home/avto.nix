{ pkgs, osConfig, ... }:

{
  ##################################################
  # USER BASICS
  ##################################################
  home.username = "avto";
  home.homeDirectory = "/home/avto";

  ##################################################
  # SESSION VARIABLES
  ##################################################
  home.sessionVariables = {
    HOSTNAME_FROM_FLAKE = osConfig.networking.hostName;

    EDITOR = "nvim";
    VISUAL = "nvim";
    NVIM_APPNAME = "nvim";
  };

  ##################################################
  # IMPORTS
  #
  # ⚠️ ყურადღება:
  # - graphical-session-marker ამოღებულია
  # - მხოლოდ Hyprland → graphical-session bridge რჩება
  ##################################################
  imports = [
    ./zsh/zsh.nix
    ./config/config.nix

    # ./systemd/graphical-session-bridge.nix
    ./systemd/waybar.nix
  ];

  ##################################################
  # PACKAGES
  ##################################################
  home.packages = with pkgs; [
    git
    neovim
    jq
  ];

  ##################################################
  # WAYBAR
  #
  # - კონფიგი მართავს Home Manager
  # - systemd service-ს ჩვენ თვითონ ვწერთ (ქვემოთ)
  ##################################################
  programs.waybar = {
    enable = true;

    # ⚠️ ძალიან მნიშვნელოვანია:
    # HM-ს არ ვაძლევთ უფლება systemd unit შექმნას
    systemd.enable = false;
  };

  ##################################################
  # GIT
  ##################################################
  programs.git.enable = true;

  ##################################################
  # REQUIRED BY HOME-MANAGER
  ##################################################
  home.stateVersion = "25.11";
}

