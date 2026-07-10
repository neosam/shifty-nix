{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/85df384c9bbd.zip").packages.${pkgs.system}.frontend;
in
  frontend
