{ pkgs ? import <nixpkgs> {}, features ? [] }:
let
  specificPkgs = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "e9ee548d90ff586a6471b4ae80ae9cfcbceb3420";
    sha256 = "sha256-4Zu0RYRcAY/VWuu6awwq4opuiD//ahpc2aFHg2CWqFY=";
  }) {};
  src = pkgs.fetchzip {
    url = "https://github.com/neosam/shifty-dioxus/releases/download/v0.1.10-dev-02/shifty-frontend-v0.1.10-dev-02.tgz";
    sha256 = "sha256-x2hzd9wNF7jkd0wO9LMam+alTCz8gP/yMioavMY579c=";
  };
  mkDerivation = specificPkgs.stdenv.mkDerivation;
in
  mkDerivation {
    pname = "shifty-frontend";
    version = "v0.1.10-dev-02";
    src = src;

    installPhase = ''
      echo cp -r $src/* $out
      mkdir -p $out
      cp -r $src/* $out/
    '';
  }
