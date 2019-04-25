#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob globstar

. lib/*.sh

readonly POST_INSTALL="POST-INSTALL.sh"

sync_configs() {
  rsync --exclude ".git/" \
    --exclude ".gitignore" \
    --exclude ".DS_Store" \
    --exclude "README.md" \
    --exclude "POST-INSTALL.sh" \
    --exclude "extra-configs" \
    --exclude "scripts/" \
    --exclude "setup.sh" \
    --exclude "brew" \
    -avh --no-perms . ~;

  # This _will_ override an existing config
  ln -sf "$PWD"/extra-configs/vscode-settings.json "$VS_CODE_DEST"
}

source_install_scripts() {
  for script in scripts/*.sh; do
    source "$script"
  done
}

main() {
  echo "Configuring additional scripts"
  # source_install_scripts
  echo "Bootstrapping..."
  sync_configs
  [[ -r "$POST_INSTALL" ]] && [[ -f "$POST_INSTALL" ]] && source "$POST_INSTALL"
  echo "Done."

  exit 0
}

main
