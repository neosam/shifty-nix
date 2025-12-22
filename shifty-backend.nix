{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  backend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/v1.7.0.zip").packages.${pkgs.system}.backend-oidc;
in
  backend
#  rustPlatform.buildRustPackage {
#    pname = "shifty-service";
#    version = "v1.7.0";
#    src = src;
#    nativeBuildInputs = with specificPkgs; [curl];
#    buildFeatures = features;
#    buildNoDefaultFeatures = true;
#    SQLX_OFFLINE = "true";
#
#    postInstall = ''
#  cp -r $src/migrations $out/
#
#  # Create the conversion script
#  echo "#!${specificPkgs.bash}/bin/bash" > $out/bin/convert_durations.sh
#  echo "${specificPkgs.gawk}/bin/awk '{
#    while (match(\$0, /[0-9]+(\\.[0-9]+)?(ns|µs|ms|s)/)) {
#      start = RSTART
#      len = RLENGTH
#      match_str = substr(\$0, start, len)
#      unit = substr(match_str, length(match_str) - length(\"ns\") + 1)
#      num = substr(match_str, 1, length(match_str) - length(unit))
#      nanoseconds = num
#      if (unit == \"ns\") {
#        nanoseconds = num
#      } else if (unit == \"µs\") {
#        nanoseconds = num * 1000
#      } else if (unit == \"ms\") {
#        nanoseconds = num * 1000000
#      } else if (unit == \"s\") {
#        nanoseconds = num * 1000000000
#      }
#      \$0 = substr(\$0, 1, start - 1) nanoseconds substr(\$0, start + len)
#    }
#    print
#  }'" >> $out/bin/convert_durations.sh
#  chmod a+x $out/bin/convert_durations.sh
#
#  # Create the start script
#  echo "#!${specificPkgs.bash}/bin/bash" > $out/bin/start.sh
#  echo "set +a" >> $out/bin/start.sh
#  echo "${specificPkgs.sqlx-cli}/bin/sqlx db setup --source $out/migrations/sqlite" >> $out/bin/start.sh
#  echo "$out/bin/shifty_bin | $out/bin/convert_durations.sh" >> $out/bin/start.sh
#  chmod a+x $out/bin/start.sh
#  '';
#
#    cargoHash = "";
#  }

