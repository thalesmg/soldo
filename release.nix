let
  sources = import ./nix/sources.nix;
  nixpkgs = import sources.nixpkgs {};
  buildDune2Package = nixpkgs.ocamlPackages.buildDunePackage.override {
    dune = nixpkgs.ocamlPackages.dune_2;
  };
  opkgs = nixpkgs.ocamlPackages;
  piaf = buildDune2Package {
    pname = "piaf";
    version = "0.1.0";
    src = sources.piaf;
    buildInputs = [
      opkgs.ssl
      opkgs.magic-mime
      opkgs.lwt_ssl
      opkgs.logs
      opkgs.uri
      opkgs.bigstringaf
      opkgs.psq
      opkgs.angstrom
      opkgs.base64
      httpaf-lwt-unix
      hpack
      h2
      h2-lwt
      h2-lwt-unix
      httpaf
      gluten
      gluten-lwt
      gluten-lwt-unix
      faraday
      faraday-lwt
      faraday-lwt-unix
    ];
  };
  hpack = buildDune2Package {
    pname = "hpack";
    version = "0.1.0";
    src = sources.ocaml-h2;
    buildInputs = [
      opkgs.angstrom
      faraday
    ];
  };
  h2 = buildDune2Package {
    pname = "h2";
    version = "0.1.0";
    src = sources.ocaml-h2;
    buildInputs = [
      hpack
      opkgs.angstrom
      faraday
      opkgs.psq
      opkgs.bigstringaf
      opkgs.base64
      httpaf
    ];
  };
  h2-lwt = buildDune2Package {
    pname = "h2-lwt";
    version = "0.1.0";
    src = sources.ocaml-h2;
    buildInputs = [
      hpack
      h2
      opkgs.angstrom
      faraday
      faraday-lwt
      opkgs.psq
      opkgs.bigstringaf
      opkgs.base64
      opkgs.lwt
      httpaf
      gluten
      gluten-lwt
    ];
  };
  h2-lwt-unix = buildDune2Package {
    pname = "h2-lwt-unix";
    version = "0.1.0";
    src = sources.ocaml-h2;
    buildInputs = [
      hpack
      opkgs.angstrom
      faraday
      faraday-lwt
      faraday-lwt-unix
      opkgs.psq
      opkgs.bigstringaf
      opkgs.base64
      opkgs.lwt
      httpaf
      h2
      h2-lwt
      gluten
      gluten-lwt
      gluten-lwt-unix
    ];
  };
  gluten = buildDune2Package {
    pname = "gluten";
    version = "0.1.0";
    src = sources.gluten;
    buildInputs = [
      faraday
      opkgs.bigstringaf
    ];
  };
  gluten-lwt = buildDune2Package {
    pname = "gluten-lwt";
    version = "0.1.0";
    src = sources.gluten;
    buildInputs = [
      faraday
      faraday-lwt
      opkgs.lwt
      opkgs.bigstringaf
      gluten
    ];
  };
  gluten-lwt-unix = buildDune2Package {
    pname = "gluten-lwt-unix";
    version = "0.1.0";
    src = sources.gluten;
    buildInputs = [
      faraday
      faraday-lwt
      faraday-lwt-unix
      opkgs.lwt
      opkgs.bigstringaf
      gluten
      gluten-lwt
    ];
  };
  aws-lambda-ocaml-runtime = buildDune2Package {
    pname = "lambda-runtime";
    version = "0.1.0";
    src = sources.aws-lambda-ocaml-runtime;
    buildInputs = [
      opkgs.ppx_deriving_yojson
      piaf
    ];
  };
  httpaf = buildDune2Package {
    pname = "httpaf";
    version = "0.1.0";
    src = sources.httpaf;
    buildInputs = [
      opkgs.bigstringaf
      opkgs.angstrom
      opkgs.faraday
    ];
  };
  faraday = buildDune2Package {
    pname = "faraday";
    version = "0.1.0";
    src = sources.faraday;
    buildInputs = [
      opkgs.bigstringaf
    ];
  };
  faraday-lwt = buildDune2Package {
    pname = "faraday-lwt";
    version = "0.1.0";
    src = sources.faraday;
    buildInputs = [
      faraday
      opkgs.bigstringaf
      opkgs.lwt
    ];
  };
  faraday-lwt-unix = buildDune2Package {
    pname = "faraday-lwt-unix";
    version = "0.1.0";
    src = sources.faraday;
    buildInputs = [
      opkgs.bigstringaf
      opkgs.lwt
      faraday
      faraday-lwt
    ];
  };
  httpaf-lwt-unix = buildDune2Package {
    pname = "httpaf-lwt-unix";
    version = "0.1.0";
    src = sources.httpaf;
    buildInputs = [
      httpaf
      opkgs.lwt
      opkgs.bigstringaf
      opkgs.angstrom
      faraday
      faraday-lwt
      faraday-lwt-unix
    ];
  };
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
      aws-lambda-ocaml-runtime
    ];
  };
}
