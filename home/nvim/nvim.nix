{ pkgs, config, ... }:

let
  devMode = true;

  nvchadDevPath = "${config.home.homeDirectory}/Projects/nvchad-2.5-config";

  nvchadPinned = pkgs.fetchgit {
    url = "https://github.com/avtotrainer/nvchad-2.5-config.git";
    rev = "5cab1149242dbf9b0f9e43545e3329f80252fe9c";
    hash = "sha256-QwV9SMx3KcLdesEYCiP9tNPXnE+E1GlEfuLztpo01LY=";
  };
in
{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPython3Packages = ps: [ ps.pynvim ];
  };

  xdg.configFile."nvim" = {
    source =
      if devMode
      then config.lib.file.mkOutOfStoreSymlink nvchadDevPath
      else nvchadPinned;

    recursive = true;
    force = true;
  };

  home.packages = with pkgs; [
    git
    curl
    unzip
    gzip
    gnutar

    ripgrep
    fd
    fzf

    gcc
    gnumake
    cmake
    pkg-config

    xclip
    wl-clipboard

    nil
    lua-language-server
    stylua
    marksman

    shellcheck
    shfmt
    nodePackages.bash-language-server

    python312
    ruff
    black
    pyright

    nodejs_22
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.prettier
    prettierd
    nodePackages.yaml-language-server
    taplo

    go
    gopls
    rustc
    cargo
    rust-analyzer

    steam-run
  ];
}
