{ config, pkgs, hostname, ... }:

{
  home.username = "avto";
  home.homeDirectory = "/home/avto";

  # ----------------------------------------
  # Home Manager safety: backup existing files
  # ----------------------------------------
  home-manager.backupFileExtension = "bak";

  home.sessionVariables = {
    HOSTNAME_FROM_FLAKE = hostname;
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  imports = [
    ./zsh/zsh.nix
    ./nvim/nvim.nix
  ];

  home.packages = with pkgs; [
    git
    vscode

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
    settings = {
      user.name = "avto";
      user.email = "avto@example.com";
    };
  };

  home.stateVersion = "25.11";
}
