# allancalix Dotfiles
_My development environment setup._

## Installation

### Prerequisites
1. Binaries found in `REQUIREMENTS` must be installed on the system.
```bash
./setup.sh
```

After configuration, `setup.sh` will automatically source `POST-INSTALL.sh` if
one exists. This is useful for appending per system configuration.

An example might be:
```bash
git config --global user.name "Jane Doe"
git config --global user.email "jane.doe@mailinator.com"
```

### Homebrew Installs
```bash
./brew.sh
```

### Mac Settings
```bash
./macos.sh
```

## Other dotfiles to checkout...
* [Mathias Bynens](https://github.com/mathiasbynens/dotfiles)