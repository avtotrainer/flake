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
  # PACKAGES (NO WAYBAR HERE)
  ##################################################
  home.packages = with pkgs; [
    git
    neovim
  ];

  ##################################################
  # WAYBAR — CORRECT, DECLARATIVE WAY
  ##################################################
  programs.waybar = {
    enable = true;

    # თუ დაგჭირდება debug:
    # systemd.enable = true;  # default = true
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

