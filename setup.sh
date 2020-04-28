#!/usr/bin/env bash
source lib/lib.sh || exit

while IFS= read -r binary; do
  env::verify_dependency "$binary"
done < "REQUIREMENTS"

readonly POST_INSTALL="POST-INSTALL.sh"

main() {
  vim::install_package_manager
  zsh::install_prompt

  echo "Installing additional dependencies..."
  vim::install_packages
  [[ -r "$POST_INSTALL" ]] && [[ -f "$POST_INSTALL" ]] && source "$POST_INSTALL"
  echo "Done."

  exit 0
}

main
