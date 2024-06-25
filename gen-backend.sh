#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

VERSION=$1
TEMPLATE_PATH="./shifty-backend-template.nix"
OUTPUT_PATH="./shifty-backend.nix"

sed -e "s/__VERSION__/$VERSION/g" -e "s/__SHA256__//g" $TEMPLATE_PATH > $OUTPUT_PATH

output=$(nix-build $OUTPUT_PATH 2>&1)

sha_line=$(echo "$output" | grep "got:\s*sha256-")

echo $sha_line

sha256=$(echo "$sha_line" | sed 's/\s*got:\s*//')

echo "'$sha256'"

sed -e "s/__VERSION__/$VERSION/g" -e "s|__SHA256__|$sha256|g" $TEMPLATE_PATH > $OUTPUT_PATH

./build-oidc-backend.sh
