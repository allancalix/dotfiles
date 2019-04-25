#!/usr/bin/env bash

Zsh_install_prompt() {
  local spaceship="https://github.com/denysdovhan/spaceship-prompt"
  local zsh_root="dotfiles/.zsh"
  local spaceship_path="$PWD/vendor/spaceship-prompt"

  mkdir -p "vendor"
  mkdir -p "$zsh_root/themes"

  if [[ -d "$spaceship_path" ]]; then
    echo "Pulling latest from $spaceship"
    git -C "$spaceship_path" pull
  else
    git clone "$spaceship" "$spaceship_path"
  fi

  ln -sf "$spaceship_path/spaceship.zsh" "$zsh_root/themes/prompt_spaceship_setup"
  echo "export SPACESHIP_ROOT=$spaceship_path" > "dotfiles/.zsh.local"
}