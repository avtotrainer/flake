{ pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.enableAllFirmware = true;

  networking.networkmanager.enable = true;

  services.upower.enable = true;
  zramSwap.enable = true;

  programs.zsh.enable = true;

  # nixpkgs.config.allowUnfree = true;
}

