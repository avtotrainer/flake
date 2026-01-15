{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    # Plugins only — no config here
    plugins = with pkgs.vimPlugins; [
      vim-nix
      plenary-nvim
      telescope-nvim
      nvim-treesitter.withAllGrammars
      lualine-nvim
    ];
  };

  # Your actual Neovim config (Lua)
  xdg.configFile."nvim/init.lua".text = ''
    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.expandtab = true
    vim.o.shiftwidth = 2
    vim.o.tabstop = 2
    vim.o.clipboard = "unnamedplus"

    require("lualine").setup()
  '';
}
