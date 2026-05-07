#!/usr/bin/env bash

set -e

VERSION=$(cat backend-version.txt)
SERVER=shifty.nebenan-unverpackt.de
ARCHIVE_URL="https://github.com/neosam/shifty-backend/archive/$VERSION.zip"

echo "build backend ($VERSION)"
nix build "$ARCHIVE_URL#backend-oidc"

echo "copy backend to $SERVER"
nix-copy-closure --to "$SERVER" result

echo "build frontend ($VERSION)"
nix build "$ARCHIVE_URL#frontend"

echo "copy frontend to $SERVER"
nix-copy-closure --to "$SERVER" result
