#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob globstar

readonly POST_INSTALL="POST-INSTALL.sh"

sync_configs() {
  # Does not remove extraneous files
  rsync --exclude ".git/" \
    --exclude ".gitignore" \
    --exclude ".DS_Store" \
    --exclude "README.md" \
    --exclude "POST-INSTALL.sh" \
    --exclude "scripts/" \
    --exclude "setup.sh" \
    --exclude "brew" \
    -avh --no-perms . ~;
}

source_install_scripts() {
  for script in scripts/*.sh; do
    source "$script"
  done
}

main() {
  echo "Configuring additional scripts"
  source_install_scripts
  echo "Bootstrapping..."
  sync_configs
  [[ -r "$POST_INSTALL" ]] && [[ -f "$POST_INSTALL" ]] && source "$POST_INSTALL"
  echo "Done."

  exit 0
}

main
