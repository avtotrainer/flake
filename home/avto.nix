{ pkgs, osConfig, ... }:

{
  home.username = "avto";
  home.homeDirectory = "/home/avto";

  home.sessionVariables = {
    HOSTNAME_FROM_FLAKE = osConfig.networking.hostName;
    EDITOR = "nvim";
    VISUAL = "nvim";
    NVIM_APPNAME = "nvim";
  };

  imports = [
    ./zsh/zsh.nix
    ./config/config.nix
  ];

  home.packages = with pkgs; [
    git
    neovim
    waybar
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "avto";
      email = "avto@example.com";
    };
  };

  home.stateVersion = "25.11";
}
