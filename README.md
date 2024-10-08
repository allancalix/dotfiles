# dotfiles
Contains configuration for my development machines that uses [home-manager] to manage installing applications and setting up configuration for those applications. Some applications that are setup using home manager in this repository include:

- [Neovim](https://neovim.io/)
- [Starship](https://starship.rs/)
- [Fish](https://fishshell.com/)

## Initial setup

1. Install [home-manager]
2. Perform initial install and configure the system
    ```bash
    ./update.sh
    ```

## Updating the system configuration

Updating the system configuration is done by running the same `./update.sh` command described in the [initial setup](#initial-setup).

Some files are written using [nickel](https://github.com/tweag/nickel) and then converted to the expected format for the tools to consume. This saves some trouble in looking up the schema for a configuration file and allows for configuration validation before updating the system.

To regenerate the nickel files run the `./update.sh --regenerate` command. The updated files should be committed to the repository.

## How-to

### Install programs for development

```nix
home.packages = with pkgs; [
  ripgrep
  fd
  eza
  gh
]
```

### Install Vim plugins

```nix
programs.neovim = {
  ...
  plugins = with pkgs.vimPlugins; [
    vim-surround
    tabular
    vim-commentary
    hop-nvim
}
```

### Define shell environment variables

```nix
home.sessionVariables = {
  EDITOR = "nvim";
  GIT_EDITOR = "nvim -u ~/.config/nvim/minimal.vim";
  PAGER = "less -RFX";
}
```

<!-- References -->
[home-manager]: https://nix-community.github.io/home-manager/

## Mac OS
Mac system configuration is not managed by home-manager. The configuration is stored in the [script/macos](./script/macos) file and executed with the `./script/bootstrap` script.

## References

People sharing how they setup and configure their systems has been incredibly inspirational. Below are some references to other setups that informed some choices made here.

- [NixOS Configuration](https://github.com/mitchellh/nixos-config)
- [Mathias Bynens' macOS Setup](https://mathiasbynens.github.io/dotfiles/macos/)
