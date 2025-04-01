#!/usr/bin/env bash
# Updates the system configuration to match the current repository state.
#
# Usage: ./update.sh
set -eou pipefail

home-manager switch --flake ./#allancalix

