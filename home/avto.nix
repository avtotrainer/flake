{ config, pkgs, hostname, ... }:

{
  home.username = "avto";
  home.homeDirectory = "/home/avto";

  # -------------------------
  # Session variables
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
    ./config/config.nix
  ];

  # -------------------------
  # User packages
  # -------------------------
  home.packages = with pkgs; [
    git
    neovim
    vscode
    waybar

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

  # -------------------------
  # Git
  # -------------------------
  programs.git = {
    enable = true;
    settings = {
      user.name = "avto";
      user.email = "avto@example.com";
    };
  };

  home.stateVersion = "25.11";
}
