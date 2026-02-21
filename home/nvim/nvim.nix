{ pkgs, config, ... }:

let
  # DEV toggle:
  # true  -> ~/.config/nvim იქნება out-of-store symlink (რედაქტირებადი repo)
  # false -> ~/.config/nvim იქნება pinned fetchgit (რეპროდუცირებადი)
  devMode = true;

  # აქ იგულისხმება, რომ NvChad config repo ლოკალურად გექნება ამ მისამართზე
  # (შეგიძლია სხვა path-იც ჩასვა)
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

    # Providers — რომ :checkhealth არ გიღრიალებდეს
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    # python provider (pynvim) — დეკლარატიულად
    extraPython3Packages = ps: [ ps.pynvim ];

    # IMPORTANT:
    # NvChad მართავს ~/.config/nvim-ს, ამიტომ აქ არ ვწერთ init.lua-ს
    # და არ ვაყენებთ plugins-ს programs.neovim.plugins-ით (კოლიზია იქნება).
  };

  # NvChad config — DEV ან PINNED
  xdg.configFile."nvim" = {
    source =
      if devMode
      then config.lib.file.mkOutOfStoreSymlink nvchadDevPath
      else nvchadPinned;

    recursive = true;

    # თუ ~/.config/nvim ადრე დირექტორია/ფაილი იყო, ამას დეკლარატიულად გადააწერს symlink-ით
    force = true;
  };

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

    # Clipboard helpers
    xclip
    wl-clipboard

    # Nix / Lua / Markdown tooling
    nil
    lua-language-server
    stylua
    marksman

    # Shell tooling
    shellcheck
    shfmt
    nodePackages.bash-language-server

    # Python tooling
    python312
    ruff
    black
    pyright
    ruff-lsp

    # Web tooling (TS/JS/HTML/CSS/JSON)
    nodejs_22
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.prettier
    prettierd
    nodePackages.yaml-language-server
    taplo

    # Go / Rust
    go
    gopls
    rustc
    cargo
    rust-analyzer

    # Codeium/Windsurf-ისთვის (wrapper ხშირად გჭირდება)
    steam-run
  ];
}
