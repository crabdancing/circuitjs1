# flake.nix
{
  inputs = {
    mvn2nix.url = "github:fzakaria/mvn2nix";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, mvn2nix, utils, ... }:
  let
    pkgsForSystem = system: import nixpkgs {
      # ./overlay.nix contains the logic to package local repository
      overlays = [ mvn2nix.overlay (import ./overlay.nix) ];
      inherit system;
    };
  in utils.lib.eachSystem utils.lib.defaultSystems (system: rec {
    legacyPackages = pkgsForSystem system;
    packages = utils.lib.flattenTree {
      inherit (legacyPackages) circuitjs1;
    };
    defaultPackage = legacyPackages.circuitjs1;
      devShells.default = legacyPackages.mkShell {
        nativeBuildInputs = [
          mvn2nix.packages.${system}.mvn2nix
        ];
      };
  });
}
