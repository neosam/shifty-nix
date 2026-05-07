{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/__VERSION__.zip").packages.${pkgs.system}.frontend;
in
  frontend
