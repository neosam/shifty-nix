{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/9cbe151d6e8a.zip").packages.${pkgs.system}.frontend;
in
  frontend
