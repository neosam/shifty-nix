{ pkgs ? import <nixpkgs> {}, features ? [] }:
let
  specificPkgs = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "cb9a96f23c491c081b38eab96d22fa958043c9fa";
    sha256 = "sha256-IAoYyYnED7P8zrBFMnmp7ydaJfwTnwcnqxUElC1I26Y=";
  }) {};
  src = pkgs.fetchzip {
    url = "https://github.com/neosam/shifty-dioxus/releases/download/v0.11.0-dev-09/shifty-frontend-v0.11.0-dev-09.tgz";
    sha256 = "sha256-YBPJp1vfO8L7bUrbcGgjEaLMo92JjbnUAuILv20stEg=";
  };
  mkDerivation = specificPkgs.stdenv.mkDerivation;
in
  mkDerivation {
    pname = "shifty-frontend";
    version = "v0.11.0-dev-09";
    src = src;

    installPhase = ''
      echo cp -r $src/* $out
      mkdir -p $out
      cp -r $src/* $out/
    '';
  }
