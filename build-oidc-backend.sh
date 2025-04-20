#!/usr/bin/env bash

nix-build ./shifty-backend.nix --arg features '["oidc" "json_logging"]'
