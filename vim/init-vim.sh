#!/usr/bin/env bash
set -euo pipefail

readonly pkg_manager="https://github.com/k-takata/minpac.git"

install_package_manager() {
  pkg_path="vim/pack/minpac/opt"
  mkdir -p "$pkg_path"
  git clone "$pkg_manager" "$pkg_path""/minpac"
}

init_vim() {
  rm -rf vim/pack
  install_package_manager
}
