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
  ##################################################
  imports = [
    ./zsh/zsh.nix
    ./config/config.nix
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
  # WAYBAR — CONFIG managed by HM, START managed by NixOS systemd
  ##################################################
  programs.waybar = {
    enable = true;

    # მნიშვნელოვანია:
    # HM-მა რომ არ შექმნას საკუთარი waybar.service (ჩვენ უკვე გვაქვს სისტემური),
    # ამით ვუთიშავთ HM-ის systemd integration-ს.
    systemd.enable = false;
  };

  ##################################################
  # GIT
  ##################################################
  programs.git = {
    enable = true;
    settings = {
      user.name = "avto";
      user.email = "avto@example.com";
    };
  };

  ##################################################
  # REQUIRED BY HOME-MANAGER
  ##################################################
  home.stateVersion = "25.11";
}

