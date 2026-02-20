{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs: let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {inherit system;};
    inherit (inputs.nixpkgs.lib) nixosSystem;
  in {
    nixosConfigurations.noninfra = nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./modules.nix
      ];
    };
    devShells.${system}.default = pkgs.mkShell {
      packages = let

        remote = "crol.bar";

        deploy = pkgs.writers.writeBashBin "deploy" ''
          nixos-rebuild --flake .#noninfra build

          if [ $? -ne 0 ]; then
            echo "system build falied"
            exit
          fi

          nix-copy-closure --to crolbar@${remote} ./result

          if [ $? -ne 0 ]; then
            echo "system copy falied"
            exit
          fi

          system=$(readlink ./result)

          ssh crolbar@${remote} " \
          sudo nix-env --profile /nix/var/nix/profiles/system --set $system && \
          sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch"
        '';
      in [
        deploy
      ];
    };
  };
}
