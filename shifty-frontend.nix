{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/5222d53b6156.zip").packages.${pkgs.system}.frontend;
in
  frontend
