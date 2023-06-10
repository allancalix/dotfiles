#!/usr/bin/env bash

set -eu

if command -v oc >/dev/null 2>&1; then
  oc scripts/link_apps.ml
  exit 0
fi

fd --maxdepth 1 . $HOME/.nix-profile/Applications --exec basename | while read -r file; do
  target="${HOME}/Applications/${file}"

  echo "$target"
  if [[ -d "$target" ]]; then
    echo "File ${file} already exists, skipping linking."
  else
    echo "Creating link for ${file}."
    ln -s "${HOME}/.nix-profile/Applications/{}" "$target"
  fi
done
