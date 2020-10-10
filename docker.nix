{ tag ? "latest"
}:

let
  sources = import ./nix/sources.nix;
  nixpkgs = import sources.nixpkgs {};
  soldo = (import ./release.nix).soldo;
  # needed by conduit-http in current nixpkgs
  # https://github.com/mirage/ocaml-conduit/pull/311#issuecomment-655594905
  # https://github.com/mirage/ocaml-conduit/issues/308
  # https://github.com/mirage/ocaml-cohttp/issues/675
  services-file = nixpkgs.writeTextFile {
    name = "services-file";
    destination = "/etc/services";
    text = ''
    http               80/tcp
    http               80/udp
    www                80/tcp
    www                80/udp
    www-http           80/tcp
    www-http           80/udp
  '';};
in
nixpkgs.dockerTools.buildImage {
  name = "soldo";
  tag = tag;
  contents = [
    services-file
  ];
  config = {
    Cmd = [ "${soldo}/bin/main" ];
    ExposedPorts = {
      "3000" = {};
    };
  };
}
