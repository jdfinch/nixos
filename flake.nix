{
  description = "My NixOS configs.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      raider = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./hosts/raider/configuration.nix ];
      };
    };
  };
}
