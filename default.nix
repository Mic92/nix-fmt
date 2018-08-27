with import <nixpkgs> {};
ocamlPackages_latest.buildOcaml {
  name = "env";
  version = "0.0.1";
  buildInputs = [
    bashInteractive
    jbuilder
    opam
    m4
    ocamlPackages_latest.menhir
    ocamlPackages_latest.core
    ocamlPackages_latest.utop
  ];
}
