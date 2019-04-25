#!/usr/bin/env bash
set -euo pipefail

brew update
brew upgrade

# Use latest GNU CLIs
brew install coreutils

brew install moreutils
brew install findutils
brew install gnu-sed --with-default-names

# Install Zsh
brew install zsh

# Install Bash 4
brew install bash

# Update local versions of other tools
brew install openssh
brew install wget --with-iri

# Install new binaries
brew install fzf
brew install git
brew install ssh-copy-id
brew install imagemagick --with-webp
brew install --HEAD universal-ctags/universal-ctags/universal-ctags

# Remove outdated versions
brew cleanup
