{ pkgs, ... }:

{
  # xdg.configFile."alacritty".source = ./alacritty;
  xdg.configFile."hypr".source       = ./hypr;
  # xdg.configFile."waybar".source     = ./waybar;
  xdg.configFile."lsd".source        = ./lsd;
  xdg.configFile."vifm".source       = ./vifm;

  # NvChad config (pinned, reproducible)
  xdg.configFile."nvim".source = pkgs.fetchgit {
    url  = "https://github.com/avtotrainer/nvchad-2.5-config.git";
    hash = "sha256-pzSd77BSsJxvPQmgF9BPNg6bjostdUNozJl7t07oz+c=";
  };
}
