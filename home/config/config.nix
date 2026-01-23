{ pkgs, ... }:

{
  # xdg.configFile."hypr".source       = ./hypr;
  # xdg.configFile."waybar".source     = ./waybar;
  xdg.configFile."lsd".source        = ./lsd;
  xdg.configFile."vifm".source       = ./vifm;

  # NOTE:
  # nvim/NvChad კონფიგი აქედან ამოღებულია.
  # nvim-ზე ზემოქმედება ხდება მხოლოდ home/nvim/nvim.nix-იდან.
}

