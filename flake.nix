{
  description = "avto — NixOS flake (laptop + delltc +  wsl)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Claude Code — community flake, ახალი ვერსია ~1 საათში (nixpkgs კვირებით აგვიანებს).
    # overlay იყენებს ჩვენს pkgs-ს (final.callPackage), ამიტომ follows — ზედმეტი nixpkgs არ ჩამოიტვირთება.
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixos-wsl, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {

      laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
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

      delltc = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/delltc/default.nix

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

      wsl = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          nixos-wsl.nixosModules.default

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

