setenv CARGO_HOME "$XDG_CONFIG_HOME/cargo"
setenv RUSTUP_HOME "$XDG_CONFIG_HOME/rustup"
setenv CARGO_INSTALL_ROOT "$HOME"

lib::check_cmd_exists cargo
