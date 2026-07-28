{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/v2.6.4.zip").packages.${pkgs.system}.frontend;
in
  frontend
