{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/4793b97155ab.zip").packages.${pkgs.system}.frontend;
in
  frontend
