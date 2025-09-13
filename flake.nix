{
  description = "My NixOS configs.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      raider = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/raider/configuration.nix

          # 1) Flakes on
          ({ ... }: { nix.settings.experimental-features = [ "nix-command" "flakes" ]; })

          # 2) Home Manager on (for this system), and your user config
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
  };
}
