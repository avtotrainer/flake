{
  description = "avto — NixOS flake (laptop + wsl)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {

      # ----------------------------
      # Laptop host (reference)
      # ----------------------------
      laptop = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/laptop/default.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";

            home-manager.users.avto = {
              imports = [ ./home/avto.nix ];
            };
          }
        ];
      };

      # ----------------------------
      # WSL host
      # ----------------------------
      wsl = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/wsl/default.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";

            home-manager.users.avto = {
              imports = [ ./home/avto.nix ];
            };
          }
        ];
      };

    };
  };
}

