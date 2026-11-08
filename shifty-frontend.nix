{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/fix-slot-500-und-urheberschaft-v2.zip").packages.${pkgs.system}.frontend;
in
  frontend
