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

        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # აუცილებელია conflicts-ისთვის
          home-manager.backupFileExtension = "bak";

          # ⚠️ დროებითი "გადასვლის რეჟიმი":
          # HM აღარ ეცდება old broken waybar.service-ის გაპარსვას/გადართვას
          home-manager.users.avto = { ... }: {
            imports = [ ./home/avto.nix ];
            systemd.user.startServices = false;
          };
        }
      ];
    };
  };
}

