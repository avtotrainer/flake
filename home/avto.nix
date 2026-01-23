{ pkgs, osConfig, lib, ... }:

let
  isWSL = (osConfig ? wsl) && (osConfig.wsl.enable or false);
in
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

  imports =
    [
      ./nvim/nvim.nix
      ./zsh/zsh.nix
      ./direnv/direnv.nix
    ]
    ++ lib.optionals (!isWSL) [
      ./config/config.nix
      ./alacritty/alacritty.nix
      ./waybar/waybar.nix
    ];

  home.packages = with pkgs; [
    git
    jq
    tree
    ripgrep
    tmux
  ];

  programs.git.enable = true;

  # ლეპტოპზე ჩართული
  programs.waybar.enable = lib.mkIf (!isWSL) true;

  gtk = lib.mkIf (!isWSL) {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      size = 24;
      package = pkgs.bibata-cursors;
    };
  };

  home.stateVersion = "25.11";
}
