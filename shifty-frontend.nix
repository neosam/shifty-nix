{ pkgs ? import <nixpkgs> {}, features ? [] }:
let
  specificPkgs = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "cb9a96f23c491c081b38eab96d22fa958043c9fa";
    sha256 = "sha256-IAoYyYnED7P8zrBFMnmp7ydaJfwTnwcnqxUElC1I26Y=";
  }) {};
  src = pkgs.fetchzip {
    url = "https://github.com/neosam/shifty-dioxus/releases/download/v0.11.1/shifty-frontend-v0.11.1.tgz";
    sha256 = "sha256-dUPqEI5mvF4J30xnblGpz2N3D8/W5LpcQH1s6ApiSR0=";
  };
  mkDerivation = specificPkgs.stdenv.mkDerivation;
in
  mkDerivation {
    pname = "shifty-frontend";
    version = "v0.11.1";
    src = src;

    installPhase = ''
      echo cp -r $src/* $out
      mkdir -p $out
      cp -r $src/* $out/
    '';
  }
