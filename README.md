# dotfiles

Home Manager configuration for Apple Silicon macOS and ARM64/x86-64 Linux, with Fish, Neovim, Ghostty, Git, and jj.

## Build and apply

Install Nix with flakes enabled and Home Manager, then run:

```sh
nix flake check --no-build --all-systems
nix build --no-link
./update.sh
```

`nix build` builds the Home Manager generation without activating it. `update.sh` applies the configuration and can be invoked from any directory; extra arguments are forwarded to Home Manager:

```sh
./update.sh --dry-run
```

Home Manager selects `legacyPackages.<system>.homeConfigurations.allancalix` using `--flake .#allancalix`. The flake exposes the activation package as `packages.<system>.default` and as a check. Intel macOS is not exposed because the pinned unstable Nixpkgs no longer supports it.

Update dependency pins explicitly, then review and rebuild:

```sh
nix flake update
nix flake check --no-build --all-systems
nix build --no-link
```

Keep `home.stateVersion` at its original value; it controls migration compatibility, not which package versions are installed. Adopt changed defaults individually.

## Configuration

- `nix/home.nix`: packages, shell, Git/jj, SSH, and Home Manager options.
- `nix/nvim`: LazyVim configuration and plugin specifications.
- `nix/ghostty/config` and `nix/helix/config.toml`: application settings.
- `nix/scripts`: packaged shell helpers with runtime dependencies declared in Home Manager.

Prefer a Home Manager program module when it supplies configuration or integrations; otherwise add the package to `home.packages`. Flake-provided packages such as `plan` are passed directly through a module in `flake.nix`.

Format the Nix files with:

```sh
nix fmt -- flake.nix nix/home.nix
```

## Neovim plugins

Add plugin specifications under `nix/nvim/lua/plugins/`; these are loaded by lazy.nvim. Language servers and formatters come from the shell/project environment; Mason is disabled.

The Nix-managed configuration is read-only. On first launch, the checked-in `nix/nvim/lazy-lock.json` seeds a writable lockfile in Neovim's data directory. `:Lazy update` updates that writable copy; copy it back to this repository when intentionally updating the shared pins:

```sh
cp "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy-lock.json" nix/nvim/lazy-lock.json
```

`:Lazy restore` restores the versions in the writable lockfile. To use newly checked-in pins on an existing installation, copy the repository lockfile to that data directory first.

## Shell tools

`tldr` is supplied by Tealdeer, which refreshes its cache on use. Ghostty installs terminfo during interactive SSH connections; `,ssh-init-term <host>` remains available for other terminals. `,gc` collects Nix garbage, stopped Docker containers, and unused images. It does not remove Home Manager generations or Docker volumes.

Git uses `nvim --clean` for commit messages. Normal editing uses the full Neovim configuration.

## macOS settings

`./script/bootstrap` applies `script/macos` separately from Home Manager. It configures system preferences and restarts the affected UI processes; it is not part of `update.sh`.

## References

- [Home Manager manual](https://nix-community.github.io/home-manager/)
- [lazy.nvim lockfiles](https://lazy.folke.io/usage/lockfile)
- [Ghostty SSH integration](https://ghostty.org/docs/features/ssh)
- [Tealdeer](https://tealdeer-rs.github.io/tealdeer/)
