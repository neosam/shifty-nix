{ features ? [] }:
let
  specificPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/cb9a96f23c491c081b38eab96d22fa958043c9fa.tar.gz";
    sha256 = "19nv90nr810mmckhg7qkzhjml9zgm5wk4idhrvyb63y4i74ih2i0";
  }) {};
  src = specificPkgs.fetchFromGitHub {
    owner = "neosam";
    repo = "shifty-backend";
    rev = "e9621aa";
    sha256 = "sha256-8MQetBnIaXmcuEcA1xQMvPLECmKqQSJxTBsxpY4eKqU=";
  };
  rustPlatform = specificPkgs.rustPlatform;
in
  rustPlatform.buildRustPackage {
    pname = "shifty-service";
    version = "e9621aa";
    src = src;
    buildFeatures = features;
    buildNoDefaultFeatures = true;
    SQLX_OFFLINE = "true";

    postInstall = ''
      cp -r $src/migrations $out/
      echo "#!${specificPkgs.bash}/bin/bash" >> $out/bin/start.sh
      echo "set +a" >> $out/bin/start.sh
      echo "${specificPkgs.sqlx-cli}/bin/sqlx migrate run --source $out/migrations/" >> $out/bin/start.sh
      echo "$out/bin/app" >> $out/bin/start.sh
      chmod a+x $out/bin/start.sh
    '';

    cargoHash = "sha256-iRjvzwbFCGgHX3z1ShW0vGxABOLrP6VzKvnw29z5xsk=";
  }

