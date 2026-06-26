{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/a24e8ccfc992.zip").packages.${pkgs.system}.frontend;
in
  frontend
