{ ... }:
{
  imports = [
    ./hardware.nix
    ../../modules/nixos/base.nix
    ../../users/users.nix
  ];

  boot.loader.grub.enable = false;

  system.stateVersion = "25.11";
}

