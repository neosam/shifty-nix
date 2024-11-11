{ features ? [] }:
let
  specificPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/cb9a96f23c491c081b38eab96d22fa958043c9fa.tar.gz";
    sha256 = "19nv90nr810mmckhg7qkzhjml9zgm5wk4idhrvyb63y4i74ih2i0";
  }) {};
  src = specificPkgs.fetchFromGitHub {
    owner = "neosam";
    repo = "shifty-backend";
    rev = "a60bbd7";
    sha256 = "sha256-K3MBE6J8obCmeHOni19MmEkXpyFAX2dv72uWz7txyuY=";
  };
  rustPlatform = specificPkgs.rustPlatform;
in
  rustPlatform.buildRustPackage {
    pname = "shifty-service";
    version = "a60bbd7";
    src = src;
    buildFeatures = features;
    buildNoDefaultFeatures = true;
    SQLX_OFFLINE = "true";

    postInstall = ''
  cp -r $src/migrations $out/

  # Create the conversion script
  echo "#!${specificPkgs.bash}/bin/bash" > $out/bin/convert_durations.sh
  echo "${specificPkgs.gawk}/bin/awk '{
    while (match(\$0, /[0-9]+(\\.[0-9]+)?(ns|µs|ms|s)/)) {
      start = RSTART
      len = RLENGTH
      match_str = substr(\$0, start, len)
      unit = substr(match_str, length(match_str) - length(\"ns\") + 1)
      num = substr(match_str, 1, length(match_str) - length(unit))
      nanoseconds = num
      if (unit == \"ns\") {
        nanoseconds = num
      } else if (unit == \"µs\") {
        nanoseconds = num * 1000
      } else if (unit == \"ms\") {
        nanoseconds = num * 1000000
      } else if (unit == \"s\") {
        nanoseconds = num * 1000000000
      }
      \$0 = substr(\$0, 1, start - 1) nanoseconds substr(\$0, start + len)
    }
    print
  }'" >> $out/bin/convert_durations.sh
  chmod a+x $out/bin/convert_durations.sh

  # Create the start script
  echo "#!${specificPkgs.bash}/bin/bash" > $out/bin/start.sh
  echo "set +a" >> $out/bin/start.sh
  echo "${specificPkgs.sqlx-cli}/bin/sqlx migrate run --source $out/migrations/" >> $out/bin/start.sh
  echo "$out/bin/app | $out/bin/convert_durations.sh" >> $out/bin/start.sh
  chmod a+x $out/bin/start.sh
  '';

    cargoHash = "sha256-prI1zP+oA8nC3P27Rzwv4oUl7HzA+jlaT64UNM3stI0=";
  }

