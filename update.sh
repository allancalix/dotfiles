#!/usr/bin/env bash
# Updates the system configuration to match the current repository state.
#
# Usage: ./update.sh [--regenerate]
#
# --regenerate: Regenerates the configuration files defined as nickel files.
set -eou pipefail

if [[ "$*" == *"--regenerate"* ]]; then
    nickel export -f toml -o nix/starship/starship.toml ncl/starship.ncl
fi

home-manager switch --flake ./#allancalix