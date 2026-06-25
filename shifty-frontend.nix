{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/v2026.176.1.zip").packages.${pkgs.system}.frontend;
in
  frontend
