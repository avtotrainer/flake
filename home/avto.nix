{ config, pkgs, hostname, ... }:

{
  home.username = "avto";
  home.homeDirectory = "/home/avto";

  # -------------------------
  # Environment variables
  # -------------------------
  home.sessionVariables = {
    HOSTNAME_FROM_FLAKE = hostname;
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # -------------------------
  # Imports
  # -------------------------
  imports = [
    ./zsh/zsh.nix
    ./nvim/nvim.nix
  ];

  # -------------------------
  # Dev tools
  # -------------------------
  home.packages = with pkgs; [
    git

    nodejs_20
    go
    gopls

    (python312.withPackages (ps: [
      ps.pip
      ps.virtualenv
      ps.setuptools
      ps.wheel
    ]))
  ];

  programs.git = {
    enable = true;
    userName = "avto";
    userEmail = "avto@example.com";
  };

  home.stateVersion = "25.11";
}
