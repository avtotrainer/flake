{
  description = "avto — NixOS Hyprland Laptop (flake-based)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./hosts/laptop/default.nix

        # Home Manager as NixOS module
        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # IMPORTANT:
          # Do NOT put backupFileExtension here
          home-manager.users.avto = import ./home/avto.nix;
        }
      ];
    };
  };
}
