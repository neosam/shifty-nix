{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/77c9ec453a9d.zip").packages.${pkgs.system}.frontend;
in
  frontend
