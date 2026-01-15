{ config, pkgs, ... }:

{
  # ----------------------------------------
  # Nix
  # ----------------------------------------
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ----------------------------------------
  # Allow unfree packages (REQUIRED for vscode, chrome, etc.)
  # ----------------------------------------
  nixpkgs.config.allowUnfree = true;

  # ----------------------------------------
  # Base system
  # ----------------------------------------
  hardware.enableAllFirmware = true;
  networking.networkmanager.enable = true;

  services.upower.enable = true;
  zramSwap.enable = true;

  programs.zsh.enable = true;
}
