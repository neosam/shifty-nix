{ features ? [] }:
let
  specificPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/b024ced1aac25639f8ca8fdfc2f8c4fbd66c48ef.tar.gz";
    sha256 = "sha256:09dahi81cn02gnzsc8a00n945dxc18656ar0ffx5vgxjj1nhgsvy";
  }) {};
  src = specificPkgs.fetchFromGitHub {
    owner = "neosam";
    repo = "shifty-backend";
    rev = "258bb786a826";
    sha256 = "sha256-CteleM+MBM6UylGtbKqzTVyLygxiH0rLWTDCdpMHMas=";
  };
  rustPlatform = specificPkgs.rustPlatform;
in
  rustPlatform.buildRustPackage {
    pname = "shifty-service";
    version = "258bb786a826";
    src = src;
    nativeBuildInputs = with specificPkgs; [curl];
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
  echo "${specificPkgs.sqlx-cli}/bin/sqlx db setup --source $out/migrations/sqlite" >> $out/bin/start.sh
  echo "$out/bin/shifty_bin | $out/bin/convert_durations.sh" >> $out/bin/start.sh
  chmod a+x $out/bin/start.sh
  '';

    cargoHash = "sha256-eSjXvV1R/CStGcU0vHYSbmy9Fs7Wkj/x6P4cAnzdWlk=";
  }

