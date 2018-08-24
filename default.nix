with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "env";
  buildInputs = [
    bashInteractive
    jbuilder
    opam
    m4
    ocamlPackages_latest.menhir
    ocamlPackages_latest.ocaml
  ];
}
