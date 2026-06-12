{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/a86cf402b4e0.zip").packages.${pkgs.system}.frontend;
in
  frontend
