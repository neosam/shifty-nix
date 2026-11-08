{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/push-tttnsupqurop.zip").packages.${pkgs.system}.frontend;
in
  frontend
