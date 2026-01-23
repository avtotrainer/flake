{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    # Providers — რომ :checkhealth არ წუწუნებდეს
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    extraPython3Packages = ps: [ ps.pynvim ];

    # NvChad მართავს ~/.config/nvim-ს, ამიტომ აქ init.lua/plugins არ იწერება.
  };

  # NvChad config (pinned, reproducible) — ~/.config/nvim-ის ერთადერთი owner
  xdg.configFile."nvim" = {
    source = pkgs.fetchgit {
      url  = "https://github.com/avtotrainer/nvchad-2.5-config.git";
      hash = "sha256-pzSd77BSsJxvPQmgF9BPNg6bjostdUNozJl7t07oz+c=";
    };
    force = true;
  };

  # Tooling set — დეკლარატიული (შენ პლაგინებს ბინარები რომ არ დააკლდეს)
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
    bash-language-server

    python312
    ruff
    black
    pyright

    nodejs
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.prettier
    prettierd

    yaml-language-server
    taplo

    go
    gopls
    rustc
    cargo
    rust-analyzer

    steam-run
  ];
}
