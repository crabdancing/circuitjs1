# overlay.nix
final: prev: {
  circuitjs1 = final.callPackage ./myPackage.nix { };
}
