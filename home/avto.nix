{ pkgs, osConfig, lib, ... }:

let
  isWSL = (osConfig.networking.hostName or "") == "wsl";
in
{
  home.username = "avto";
  home.homeDirectory = "/home/avto";
  home.stateVersion = "25.11";

  home.sessionVariables = {
    HOSTNAME_FROM_FLAKE = osConfig.networking.hostName;
    EDITOR = "nvim";
    VISUAL = "nvim";
    NVIM_APPNAME = "nvim";
  } // lib.optionalAttrs (!isWSL) {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE  = "24";
  };

  imports =
    [
      ./zsh/zsh.nix
      ./direnv/direnv.nix
      ./config/config.nix
    ]
    ++ lib.optionals (!isWSL) [
      ./alacritty/alacritty.nix
      ./waybar/waybar.nix
    ];

  home.packages = with pkgs; [
    git
    neovim
    jq
    tree
    ripgrep
    tmux
  ];

  programs.git.enable = true;

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    clock24 = true;
  };

  programs.waybar.enable = lib.mkIf (!isWSL) true;

  gtk = lib.mkIf (!isWSL) {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      size = 24;
      package = pkgs.bibata-cursors;
    };
  };

  dconf.enable = lib.mkIf (!isWSL) true;
}

