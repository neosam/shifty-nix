#!/usr/bin/env bash

nix store sign --key-file /home/neosam/.nix/neosam-signing-key.pem --recursive ./result
