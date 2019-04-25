#!/usr/bin/env bash

readonly pkg_manager="https://github.com/k-takata/minpac.git"

Vim_install_package_manager() {
  readonly vim_root="dotfiles/.vim"
  # Remove existing package manager
  rm -rf "$vim_root/pack"

  pkg_path="$vim_root/pack/minpac/opt"
  mkdir -p "$vim_root/tmp"
  mkdir -p "$pkg_path"
  git clone "$pkg_manager" "$pkg_path""/minpac"
}

Vim_install_packages() {
  nvim +PackInit
}