{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/63e469e76ec8.zip").packages.${pkgs.system}.frontend;
in
  frontend
