{
  description = "avto — NixOS Hyprland Laptop (flake-based)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      inherit system pkgs;

      modules = [
        ./hosts/laptop/default.nix
      ];
    };
  };
}

