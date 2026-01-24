{ pkgs, lib, ... }:

let
  # ─────────────────────────────────────────────
  # NvChad development switch
  #
  # true  → გამოიყენება ლოკალური nvchad-2.5-config (LIVE)
  # false → გამოიყენება pinned Git repo (REPRODUCIBLE)
  # ─────────────────────────────────────────────
  useLocalNvChad = true;

  # ⚠️ ზუსტად არსებული დირექტორია
  localNvChadPath = "/home/avto/nvchad-2.5-config";

  # Pinned, reproducible NvChad config
  pinnedNvChad = pkgs.fetchgit {
    url = "https://github.com/avtotrainer/nvchad-2.5-config.git";
    rev = "5cab1149242dbf9b0f9e43545e3329f80252fe9c";
    hash = "sha256-QwV9SMx3KcLdesEYCiP9tNPXnE+E1GlEfuLztpo01LY=";
  };
in
{
  # ─────────────────────────────────────────────
  # Neovim (system/user integration only)
  # NvChad fully owns ~/.config/nvim
  # ─────────────────────────────────────────────
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    # Providers (silence :checkhealth warnings)
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    # Python provider (pynvim)
    extraPython3Packages = ps: [ ps.pynvim ];

    # IMPORTANT:
    # - no init.lua here
    # - no plugins here
    # NvChad is the only owner of ~/.config/nvim
  };

  # ─────────────────────────────────────────────
  # NvChad configuration source
  # ─────────────────────────────────────────────
  xdg.configFile."nvim" = {
    source =
      if useLocalNvChad
      then localNvChadPath
      else pinnedNvChad;

    recursive = true;
    force = true;
  };

  # ─────────────────────────────────────────────
  # User tooling required by NvChad + LSP + Codeium
  # ─────────────────────────────────────────────
  home.packages = with pkgs; [
    # Core
    git
    curl
    unzip
    gzip
    gnutar

    # Search / fuzzy
    ripgrep
    fd
    fzf

    # Native build tools (treesitter, native extensions)
    gcc
    gnumake
    cmake
    pkg-config

    # Clipboard helpers
    xclip
    wl-clipboard

    # Nix / Lua / Markdown
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

    # Web (JS / TS / HTML / CSS / JSON / YAML)
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

    # Codeium / Windsurf helper (FHS wrapper)
    steam-run
  ];
}

