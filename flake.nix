{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs.lib) nixosSystem;
  in {
    nixosConfigurations.noninfra = nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./modules.nix
      ];
    };
  };
}
