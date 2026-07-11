{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/882070d91bfe.zip").packages.${pkgs.system}.frontend;
in
  frontend
