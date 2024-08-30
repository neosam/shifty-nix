{ pkgs ? import <nixpkgs> {}, features ? [] }:
let
  specificPkgs = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "cb9a96f23c491c081b38eab96d22fa958043c9fa";
    sha256 = "sha256-IAoYyYnED7P8zrBFMnmp7ydaJfwTnwcnqxUElC1I26Y=";
  }) {};
  src = pkgs.fetchFromGitHub {
    owner = "neosam";
    repo = "shifty-backend";
    rev = "ea80839";
    sha256 = "sha256-ImpRf2RJ5YOEnbFNxxw7FONNthtc0DLCfGGGDuqpdXo=";
  };
  #src = ./.;
  rustPlatform = specificPkgs.rustPlatform;
in
  rustPlatform.buildRustPackage {
    pname = "shifty-service";
    version = "ea80839";
    src = src;
    buildFeatures = features;
    buildNoDefaultFeatures = true;
    SQLX_OFFLINE = "true";

    postInstall = ''
      cp -r $src/migrations $out/
      echo "#!${pkgs.bash}/bin/bash" >> $out/bin/start.sh
      echo "set +a" >> $out/bin/start.sh
      echo "${pkgs.sqlx-cli}/bin/sqlx migrate run --source $out/migrations/" >> $out/bin/start.sh
      echo "$out/bin/app" >> $out/bin/start.sh
      chmod a+x $out/bin/start.sh
    '';

    cargoHash = "sha256-8G0IxB3d2Tb6eguzjNvwVQScfmorkbna+ylcJdlF2gE=";
  }
