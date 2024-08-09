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
    rev = "72b588550086ec42a8fb6355894e6fdbd92eb247";
    sha256 = "sha256-ow7a9snrmVgodT4eXfL8JZuUVFVxbhvaNSfzT0A1uCo=";
  };
  #src = ./.;
  rustPlatform = specificPkgs.rustPlatform;
in
  rustPlatform.buildRustPackage {
    pname = "shifty-service";
    version = "72b588550086ec42a8fb6355894e6fdbd92eb247";
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

    cargoHash = "sha256-P58P+peiBYD2g8Is9Jk1Fp4sw7XKOuOgEuKWg0Plg+w=";
  }
