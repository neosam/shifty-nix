#!/usr/bin/env bash

set -euo pipefail

# Update the shifty-backend deployment pin to <version>, verify it builds, then
# commit + tag the shifty-nix repo. Mirrors the backend's cli-update-version.sh.
# Deploy is NOT run here — do that separately via ./deploy-binaries.sh (or
# ./build-and-deploy.sh) once this pin is committed.
#
# Usage: cli-release.sh <version> [branch]
#   version  X.Y.Z (a leading "v" is accepted and stripped). Must match an
#            existing shifty-backend git tag vX.Y.Z on GitHub — gen-backend.sh
#            fetches https://github.com/neosam/shifty-backend/archive/vX.Y.Z.zip
#            to verify the pin, so release the backend FIRST.
#   branch   defaults to "main".

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    echo "Usage: $0 <version> [branch]" >&2
    exit 1
fi

VERSION="${1#v}"
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "ERROR: version must be X.Y.Z (got '$1')" >&2
    exit 1
fi
TAG="v$VERSION"
BRANCH="${2:-main}"

echo "Pin shifty-backend deployment to: $TAG"
echo "Branch: $BRANCH"

set -x

# Renders shifty-backend.nix + shifty-frontend.nix from the templates, builds
# both locally to verify the pin resolves, and writes backend-version.txt.
./gen-backend.sh "$TAG"

jj commit -m "$VERSION"
jj b m "$BRANCH" --to @-
# Push ONLY the release branch — shifty-nix carries several stray local
# bookmarks (dev, flakes, push-*) that must not be touched by a release.
jj git push --bookmark "$BRANCH"
git tag -a "$TAG" -m "$VERSION" "$BRANCH"
git push --tags

set +x
echo "shifty-nix pinned + tagged $TAG. Deploy separately: ./deploy-binaries.sh"
