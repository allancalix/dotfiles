#!/usr/bin/env bash
# Updates the system configuration to match the current repository state.
#
# Usage: ./update.sh [home-manager options]
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
exec home-manager switch --flake "$repo_dir#allancalix" "$@"
