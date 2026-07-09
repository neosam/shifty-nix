{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/6d0fd15fc407.zip").packages.${pkgs.system}.frontend;
in
  frontend
