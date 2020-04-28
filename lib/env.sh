#!/usr/bin/env bash
#
# Provide information about the system under configuration.

env::get_platform() {
  if [[ $(uname -s) == 'Darwin' ]]; then
    echo "MAC"
  else
    echo "LINUX"
  fi
}

# Verify a binary is available globally. If binary is not found,
# this function exits execution with error;
# Arguments:
#   1. binary_name
env::verify_dependency() {
  if [[ -z $(command -v "$1") ]]; then
    echo "$1 is required but not found."
    # Exit with error
    exit 1
  fi
}

# Get the user directory for VS Code configuration
# Arguments:
#   1. platform
env::get_vscode_config_dest() {
  if [[ "$1" == "MAC" ]]; then
    echo "$HOME/Library/Application Support/Code/User/settings.json"
  else
    echo "$HOME/.config/Code/User/settings.json"
  fi
}

# Exports
readonly PLATFORM=$(env::get_platform)
readonly VS_CODE_DEST=$(env::get_vscode_config_dest "$PLATFORM")
