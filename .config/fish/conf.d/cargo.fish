setenv CARGO_HOME "$XDG_CONFIG_HOME/cargo"
setenv RUSTUP_HOME "$XDG_CONFIG_HOME/rustup"
setenv CARGO_INSTALL_ROOT "$HOME"

lib::check_cmd_exists cargo

abbr -a c 'cargo'
abbr -a cr 'cargo run'
abbr -a cb 'cargo build'
abbr -a ct 'cargo test'
