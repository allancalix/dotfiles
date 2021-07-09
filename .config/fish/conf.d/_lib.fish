# Initial environment configuration and utility functions for all sources
# subsequently executed (which is basically everything in the ~/.config/fish
# directory). See https://fishshell.com/docs/current/index.html#initialization-files
# for more details on source file load ordering.
#
# This file is named with a leading underscore to force it to be executed before
# any files in this directory not named with an underscore. This is leveraging
# the fact that files are executed in alphanumeric order. Non library files
# should __not be named with leading underscores__.

setenv XDG_CONFIG_HOME "$HOME/.config"
setenv XDG_DATA_HOME "$HOME/.local/share"
setenv XDG_STATE_HOME "$HOME/.local/state"

setenv USER_BIN "$HOME/bin"

# Expose locally installed binaries on path.
fish_add_path $USER_BIN
# Expose Pyenv binaries on path.
fish_add_path "$PYENV_ROOT/bin"
# Expose Cargo binaries on path.
fish_add_path "$XDG_CONFIG_HOME/cargo/bin"

setenv TERMCOLOR "truecolor"

# Verifies a command exists and exits the environment if it doesn't.
# Example:
#   lib::check_cmd_exists fzf
function lib::check_cmd_exists
  set cmd_name $argv
  if ! type -q $cmd_name
    echo "Command \"$cmd_name\" not found. Skipping initialization."
    exit 0
  end
end
