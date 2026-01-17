{ config, pkgs, lib, ... }:

{
  # ----------------------------------------
  # Nix
  # ----------------------------------------
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ----------------------------------------
  # Allow unfree packages
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

  # ----------------------------------------
  # TTY autologin (DM გარეშე, მაგრამ დეკლარაციულად)
  #
  # ეს არის ის, რაც გვაძლევს user systemd-ს,
  # რომ hyprland-autostart.user service გაეშვას ავტომატურად.
  # ----------------------------------------
  services.getty.autologinUser = "avto";
}

