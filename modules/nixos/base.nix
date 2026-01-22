{ config, pkgs, lib, ... }:

{
  # ─────────────────────────────────────────────
  # Nix (flake tooling სისტემურად)
  # ─────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ─────────────────────────────────────────────
  # Allow unfree packages
  # ─────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true;

  # ─────────────────────────────────────────────
  # Base system (უსაფრთხო ყველგან)
  # ─────────────────────────────────────────────
  programs.zsh.enable = true;
}

