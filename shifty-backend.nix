{ features ? [] }:
let
  specificPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/cb9a96f23c491c081b38eab96d22fa958043c9fa.tar.gz";
    sha256 = "19nv90nr810mmckhg7qkzhjml9zgm5wk4idhrvyb63y4i74ih2i0";
  }) {};
  src = specificPkgs.fetchFromGitHub {
    owner = "neosam";
    repo = "shifty-backend";
    rev = "8ff2f7a";
    sha256 = "sha256-P6l6gDkBYbCpyZbStgXeIqRlCan7b7Eks/GJEEU0LD0=";
  };
  rustPlatform = specificPkgs.rustPlatform;
in
  rustPlatform.buildRustPackage {
    pname = "shifty-service";
    version = "8ff2f7a";
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

    cargoHash = "sha256-5ikAWsLAvjR80GPjf0f+2Jp3qlfKwiNw+VjarTrySLw=";
  }

