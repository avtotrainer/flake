{ pkgs, osConfig, ... }:

{
  home.username = "avto";
  home.homeDirectory = "/home/avto";

  home.sessionVariables = {
    HOSTNAME_FROM_FLAKE = osConfig.networking.hostName;

    EDITOR = "nvim";
    VISUAL = "nvim";
    NVIM_APPNAME = "nvim";

    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };

  imports = [
    ./zsh/zsh.nix
    ./direnv/direnv.nix
    ./config/config.nix
  ];

  home.packages = with pkgs; [
    git
    neovim
    jq
    tree
    ripgrep
  ];

  programs.waybar.enable = true;

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      size = 24;
      package = pkgs.bibata-cursors;
    };
  };

  programs.git.enable = true;

  home.stateVersion = "25.11";
}

