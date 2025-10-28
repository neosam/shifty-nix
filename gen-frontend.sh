#!/usr/bin/env bash


if [ $# -eq 0 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

VERSION=$1
TEMPLATE_PATH="./shifty-frontend-template.nix"
OUTPUT_PATH="./shifty-frontend.nix"

echo Finding hash for the git repository

sed -e "s/__VERSION__/$VERSION/g" -e "s/__REPO_HASH__//g" -e "s/__CARGO_HASH__//g" $TEMPLATE_PATH > $OUTPUT_PATH

output=$(nix-build $OUTPUT_PATH 2>&1)

sha_line=$(echo "$output" | grep "got:\s*sha256-")

echo $sha_line

repoHash=$(echo "$sha_line" | sed 's/\s*got:\s*//')

echo "'$repoHash'"

sed -e "s/__VERSION__/$VERSION/g" -e "s|__REPO_HASH__|$repoHash|g" -e "s/__CARGO_HASH__//g" $TEMPLATE_PATH > $OUTPUT_PATH

echo Finding cargo hash
output=$(./build-frontend.sh 2>&1)

sha_line=$(echo "$output" | grep "got:\s*sha256-")

echo $sha_line

cargoHash=$(echo "$sha_line" | sed 's/\s*got:\s*//')

echo "'$cargoHash'"

sed -e "s/__VERSION__/$VERSION/g" -e "s|__REPO_HASH__|$repoHash|g" -e "s|__CARGO_HASH__|$cargoHash|g" $TEMPLATE_PATH > $OUTPUT_PATH

set -e

echo Finally, we can build
./build-frontend.sh

echo $VERSION > frontend-version.txt

