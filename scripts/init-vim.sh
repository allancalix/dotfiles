#!/usr/bin/env bash

readonly pkg_manager="https://github.com/k-takata/minpac.git"

install_package_manager() {
  pkg_path=".vim/pack/minpac/opt"
  mkdir -p ".vim/tmp"
  mkdir -p "$pkg_path"
  git clone "$pkg_manager" "$pkg_path""/minpac"
}

install_packages() {
  vim +PackInit
}

init_vim() {
  rm -rf .vim/pack
  install_package_manager
  install_packages
}

init_vim
