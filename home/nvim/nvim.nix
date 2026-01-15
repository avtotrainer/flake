{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-nix
      plenary-nvim
      telescope-nvim
      nvim-treesitter.withAllGrammars
      lualine-nvim
    ];

    extraConfig = ''
      set number
      set relativenumber
      set expandtab
      set shiftwidth=2
      set tabstop=2
      set clipboard=unnamedplus
    '';
  };
}
