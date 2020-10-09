let
  sources = import ./nix/sources.nix;
  nixpkgs = import sources.nixpkgs {};
  buildDune2Package = nixpkgs.ocamlPackages.buildDunePackage.override {
    dune = nixpkgs.ocamlPackages.dune_2;
  };
  opkgs = nixpkgs.ocamlPackages;
in
{
  soldo = buildDune2Package {
    pname = "soldo";
    version = "1.0.0";
    src = ./.;
    buildInputs = [
      opkgs.core
      opkgs.lambdasoup
      opkgs.lwt
      opkgs.cohttp
      opkgs.cohttp-lwt-unix
      opkgs.re2
      opkgs.ppx_jane
      opkgs.ppx_deriving_yojson
      opkgs.opium
      opkgs.opium_kernel
    ];
  };
}
