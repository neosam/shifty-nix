{ pkgs ? import <nixpkgs> {}, features ? [] }:
let
  specificPkgs = import (pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "e9ee548d90ff586a6471b4ae80ae9cfcbceb3420";
    sha256 = "sha256-4Zu0RYRcAY/VWuu6awwq4opuiD//ahpc2aFHg2CWqFY=";
  }) {};
  src = pkgs.fetchFromGitHub {
    owner = "neosam";
    repo = "shifty-backend";
    rev = "e7c247d41ee6ae96cad09a2b6296ed046d7bea8d";
    sha256 = "sha256-gkmhh5leu0MlfwyEsdGPZjvSGSW9XNkPhGl3koiZm9s=";
  };
  #src = ./.;
  rustPlatform = specificPkgs.rustPlatform;
in
  rustPlatform.buildRustPackage {
    pname = "shifty-service";
    version = "e7c247d41ee6ae96cad09a2b6296ed046d7bea8d";
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

    cargoHash = "sha256-mYrSRRwldWcffRAqqa05ZliY0eVmkMURXN3ui0baqfE=";
  }
