#!/usr/bin/env bash

# Single-source generator for backend AND frontend pin files.
# After the shifty-dioxus → shifty-backend co-location (Phase 5/6), the frontend
# is built from the same shifty-backend flake (packages.frontend), so both
# pin files share one version.

if [ $# -eq 0 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

VERSION=$1

# Backend pin
sed -e "s/__VERSION__/$VERSION/g" \
    ./shifty-backend-template.nix > ./shifty-backend.nix

# Frontend pin (zieht aus dem gleichen shifty-backend-Flake)
sed -e "s/__VERSION__/$VERSION/g" \
    ./shifty-frontend-template.nix > ./shifty-frontend.nix

# Local build to verify the pin
./build-oidc-backend.sh
./build-frontend.sh

echo $VERSION > backend-version.txt
