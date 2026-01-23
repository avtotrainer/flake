{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    # Providers — რომ “:checkhealth” არ გიღრიალებდეს
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    # python provider (pynvim) — დეკლარატიულად
    extraPython3Packages = ps: [ ps.pynvim ];

    # IMPORTANT:
    # NvChad მართავს ~/.config/nvim-ს, ამიტომ აქ არ ვწერთ init.lua-ს
    # და არ ვაყენებთ plugins-ს programs.neovim.plugins-ით (კოლიზია იქნება).
  };

  # NvChad config (pinned, reproducible) — ~/.config/nvim-ის ერთადერთი owner
  xdg.configFile."nvim".source = pkgs.fetchgit {
    url  = "https://github.com/avtotrainer/nvchad-2.5-config.git";
    hash = "sha256-pzSd77BSsJxvPQmgF9BPNg6bjostdUNozJl7t07oz+c=";
  };

  # შენი “აქტიური პლაგინების” პრაქტიკული სრული კომპლექტი:
  # - Telescope/grep/fuzzy
  # - Treesitter/native builds
  # - LSP/formatters/linters (მეტად სრული, რომ არაფერი დაგაკლდეს)
  # - Git integration
  home.packages = with pkgs; [
    # Core tooling
    git
    curl
    unzip
    gzip
    gnutar

    # Search / fuzzy
    ripgrep
    fd
    fzf

    # Native build tools (treesitter / telescope-fzf-native / etc.)
    gcc
    gnumake
    cmake
    pkg-config

    # Clipboard helpers (ხშირად საჭიროა)
    xclip
    wl-clipboard

    # Nix / Lua / Markdown tooling (ხშირად NvChad გარემოში)
    nil
    lua-language-server
    stylua
    marksman

    # Shell tooling
    shellcheck
    shfmt
    bash-language-server

    # Python tooling
    python312
    ruff
    black
    pyright

    # Web tooling (TS/JS/HTML/CSS/JSON)
    nodejs_22
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.prettier
    nodePackages.prettierd
    yaml-language-server
    taplo

    # Go / Rust (თუ გაქვს შესაბამისი პლაგინები/LSP)
    go
    gopls
    rustc
    cargo
    rust-analyzer

    # მომავალში Codeium/Windsurf-ისთვის (NixOS-ზე wrapper ხშირად გჭირდება)
    steam-run
  ];
}

