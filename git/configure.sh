#!/usr/bin/env bash
set -euo pipefail

create_aliases() {
  git config --global alias.co "checkout"
  git config --global alias.lg "log --pretty='%Cred%h%Creset | %C(yellow)%d%Creset %s %Cgreen(%cr)%Creset %C(cyan)[%an]%Creset' --graph"
  git config --global alias.so "show --pretty='parent %Cred%p%Creset commit
  %Cred%h%Creset%C(yellow)%d%Creset%n%n%w(72,2,2)%s%n%n%w(72,0,0)%C(cyan)%an%Creset
  %Cgreen%ar%Creset'"
  git config --global alias.st "status --short --branch"
  git config --global alias.cma "commit --all -m"
  git config --global alias.dp "diff --word-diff --unified=10"
  git config --global alias.append '!git cherry-pick $(git merge-base HEAD
  $1)..$1'
}

configure_settings() {
  git config --global core.pager "less -RFX"
  # Not supported for git version < 1.8
  git config --global diff.algorithm histogram
}

configure_git() {
  create_aliases
  configure_settings
}
