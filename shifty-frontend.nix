{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/c7077447afd8.zip").packages.${pkgs.system}.frontend;
in
  frontend
