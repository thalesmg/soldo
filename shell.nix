let
  sources = import ./nix/sources.nix;
  nixpkgs = import sources.nixpkgs {};
  release = import ./release.nix;
  soldo = release.soldo;
  opkgs = nixpkgs.ocamlPackages;
in
nixpkgs.mkShell {
  buildInputs = soldo.buildInputs ++ [
    opkgs.utop
  ];
}
