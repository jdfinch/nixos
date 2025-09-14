{
  description = "My NixOS configs.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    nixosConfigurations = {
      raider = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/raider/configuration.nix

          # Flakes on
          ({ ... }: { nix.settings.experimental-features = [ "nix-command" "flakes" ]; })

          # Home Manager as a NixOS module
          home-manager.nixosModules.home-manager
          ({ ... }: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak-hm";
            home-manager.users.jdfinch = import ./jdfinch/home.nix;
          })
        ];
      };
    };

    homeConfigurations.jdfinch = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./jdfinch/home.nix ];
    };
  };

}
