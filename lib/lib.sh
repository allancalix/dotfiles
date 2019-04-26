#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob globstar

RUNTIME_PATH=$(cd "$(dirname -- "$0")" > /dev/null && pwd)
PKG_PATH=lib

# Import modules
source ${RUNTIME_PATH}/${PKG_PATH}/env.sh || exit
source ${RUNTIME_PATH}/${PKG_PATH}/vim.sh || exit
source ${RUNTIME_PATH}/${PKG_PATH}/zsh.sh || exit