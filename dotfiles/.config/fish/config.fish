source "$__fish_config_dir/aliases.fish"
source "$__fish_config_dir/prompt.fish"

# Provides a hook for system specific configuration.
if test -e "$__fish_config_dir/local.fish"
  source "$__fish_config_dir/local.fish"
end

# Switch to vi style line editing.
fish_vi_key_bindings

# Required for password loopback on linux.
setenv GPG_TTY (tty)
