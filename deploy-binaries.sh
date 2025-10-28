#!/usr/bin/env bash

set -e

BACKEND_VERSION=$(cat backend-version.txt)
FRONTEND_VERSION=$(cat frontend-version.txt)

echo build backend
nix build https://github.com/neosam/shifty-backend/archive/$BACKEND_VERSION.zip#backend-oidc

echo copy backend to server
nix-copy-closure --to shifty.nebenan-unverpackt.de result

echo build frontend version $FRONTEND_VERSION
nix build https://github.com/neosam/shifty-dioxus/archive/$FRONTEND_VERSION.zip#default

echo copy frontend to server
nix-copy-closure --to shifty.nebenan-unverpackt.de result
