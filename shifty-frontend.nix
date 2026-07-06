{ features ? [], pkgs ? import <nixpkgs> {} }:
let
  frontend = (builtins.getFlake "https://github.com/neosam/shifty-backend/archive/831ade449b54.zip").packages.${pkgs.system}.frontend;
in
  frontend
