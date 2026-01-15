{ pkgs, ... }:

{
  xdg.configFile."alacritty".source = ./alacritty;
  xdg.configFile."hypr".source       = ./hypr;
  xdg.configFile."waybar".source     = ./waybar;
  xdg.configFile."lsd".source        = ./lsd;
  xdg.configFile."vifm".source       = ./vifm;
  xdg.configFile."fontconfig".source = ./fontconfig;

  # NvChad config fetched declaratively
  xdg.configFile."nvim".source = pkgs.fetchgit {
    url = "https://github.com/avtotrainer/nvchad-2.5-config.git";
    # rev  = "main";  # optional (unpinned)
    # hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
}
