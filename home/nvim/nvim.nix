{ pkgs, lib, ... }:

let
  # ─────────────────────────────────────────────
  # NvChad source selector
  #
  # true  → local NvChad snapshot via builtins.path (PURE, rebuild required)
  # false → pinned Git repo (PURE, reproducible)
  #
  # ⚠️ NOTE:
  # This is NOT live-edit mode.
  # Any change in the local directory requires nixos-rebuild.
  # ─────────────────────────────────────────────
  useLocalNvChad = true;

  # Local NvChad directory (declared as Nix input)
  localNvChadPath = builtins.path {
    path = /home/avto/nvchad-2.5-config;
    name = "nvchad-2.5-config";
  };

  # Pinned, reproducible NvChad config
  pinnedNvChad = pkgs.fetchgit {
    url = "https://github.com/avtotrainer/nvchad-2.5-config.git";
    rev = "5cab1149242dbf9b0f9e43545e3329f80252fe9c";
    hash = "sha256-QwV9SMx3KcLdesEYCiP9tNPXnE+E1GlEfuLztpo01LY=";
  };
in
{
  # ─────────────────────────────────────────────
  # Neovim (system integration only)
  # NvChad is the sole owner of ~/.config/nvim
  # ─────────────────────────────────────────────
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    # Providers (silence :checkhealth)
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    # Python provider
    extraPython3Packages = ps: [ ps.pynvim ];

    # IMPORTANT:
    # - no init.lua here
    # - no plugins here
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
  # User tooling required by NvChad / LSP / Codeium
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

    # Native build tools
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

    # Web tooling
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

    # Codeium / Windsurf FHS wrapper
    steam-run
  ];
}

