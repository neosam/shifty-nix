{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/1031d5eaa286.zip").packages.${pkgs.system}.frontend;
in
  frontend
