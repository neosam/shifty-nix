{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/53bf66c1c358.zip").packages.${pkgs.system}.frontend;
in
  frontend
