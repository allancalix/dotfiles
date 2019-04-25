#!/usr/bin/env bash

readonly pkg_manager="https://github.com/k-takata/minpac.git"

Vim_install_package_manager() {
  # Remove existing package manager
  rm -rf .vim/pack

  pkg_path=".vim/pack/minpac/opt"
  mkdir -p ".vim/tmp"
  mkdir -p "$pkg_path"
  git clone "$pkg_manager" "$pkg_path""/minpac"
}

Vim_install_packages() {
  nvim +PackInit
}