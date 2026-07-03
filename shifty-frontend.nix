{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/v2.2.0.zip").packages.${pkgs.system}.frontend;
in
  frontend
