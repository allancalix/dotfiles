lib::check_cmd_exists cargo

setenv CARGO_HOME "$XDG_CONFIG_HOME/cargo"
setenv RUSTUP_HOME "$XDG_CONFIG_HOME/rustup"
setenv CARGO_INSTALL_ROOT "$HOME"
fish_add_path "$XDG_CONFIG_HOME/cargo/bin"
