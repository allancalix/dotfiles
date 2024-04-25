# dotfiles

## Setup

1. Install [home-manager](https://nix-community.github.io/home-manager/)

2. Create initial generation

```bash
home-manager switch --flake ./#allancalix
```

## Updates

Make changes to files in this repository and create a new `home-manager` generation with:

```bash
bb switch
```

Most programs are configured using `home-manager` configuration records but others have configuration files that are linked in the correct spots by `home-manager`.

The bulk of the configuration is defined in [home.nix](./nix/home.nix).

## Tour

A quick highlight of the some of the features `home-manager` supports:

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
