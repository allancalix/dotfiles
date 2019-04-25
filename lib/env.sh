#!/usr/bin/env bash
#
# Provide information about the system under configuration.

get_platform() {
  if [[ $(uname -s) == 'Darwin' ]]; then
    echo "MAC"
  else
    echo "LINUX"
  fi
}

# Get the user directory for VS Code configuration
# Arguments:
#   1. platform
get_vscode_config_dest() {
  if [[ "$1" == "MAC" ]]; then
    echo "$HOME/Library/Application Support/Code/User/settings.json"
  else
    echo "$HOME/.config/Code/User/settings.json"
  fi
}

# Exports
readonly PLATFORM=$(get_platform)
readonly VS_CODE_DEST=$(get_vscode_config_dest "$PLATFORM")