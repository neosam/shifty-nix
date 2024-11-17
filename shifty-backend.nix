{ features ? [] }:
let
  specificPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/76612b17c0ce71689921ca12d9ffdc9c23ce40b2.tar.gz";
    sha256 = "03pmy2dv212mmxgcvwxinf3xy6m6zzr8ri71pda1lqggmll2na12";
  }) {};
  src = specificPkgs.fetchFromGitHub {
    owner = "neosam";
    repo = "shifty-backend";
    rev = "1fb02fc";
    sha256 = "sha256-fIc4mCqBzJSeYqp3NgshGSyK+tsdseOvxquO4kb5TFs=";
  };
  rustPlatform = specificPkgs.rustPlatform;
in
  rustPlatform.buildRustPackage {
    pname = "shifty-service";
    version = "1fb02fc";
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

    cargoHash = "sha256-wxz9Tm/wSk+qEGXSXZHQIwd5xNQ92pKvR9vPA0UUoyg=";
  }

