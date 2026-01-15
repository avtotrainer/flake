{ pkgs, ... }:

{
  xdg.configFile."alacritty".source = ./alacritty;
  xdg.configFile."hypr".source       = ./hypr;
  xdg.configFile."waybar".source     = ./waybar;
  xdg.configFile."lsd".source        = ./lsd;
  xdg.configFile."vifm".source       = ./vifm;
  xdg.configFile."fontconfig".source = ./fontconfig;

  # NvChad from GitHub (authoritative source)
  xdg.configFile."nvim".source = pkgs.fetchGit {
    url = "git@github.com:avtotrainer/nvchad-2.5-config.git";
  };
}
