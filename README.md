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
- `nix/nvim`: Neovim configuration (native `vim.pack`, LSP, and completion; no distribution).
- `nix/ghostty/config` and `nix/helix/config.toml`: application settings.
- `nix/scripts`: packaged shell helpers with runtime dependencies declared in Home Manager.

Prefer a Home Manager program module when it supplies configuration or integrations; otherwise add the package to `home.packages`. Flake-provided packages such as `plan` are passed directly through a module in `flake.nix`.

Format the Nix files with:

```sh
nix fmt -- flake.nix nix/home.nix
```

## Neovim

The configuration targets Neovim 0.12 built-ins: `vim.pack` for plugins, `vim.lsp.config`/`vim.lsp.enable` with server definitions from nvim-lspconfig, `'autocomplete'` with the LSP omnifunc for completion, and the ui2 message UI. Entry points live in `nix/nvim/lua/config/`; plugins are listed and configured in `plugins.lua`.

`~/.config/nvim` links to `nix/nvim` in this checkout (an out-of-store symlink, so edits apply without `update.sh`), and `vim.pack` writes `nix/nvim/nvim-pack-lock.json` back into the repository. `home.nix` assumes the checkout is at `~/acx/src/github.com/allancalix/dotfiles`; change `dotfilesDir` if it lives elsewhere.

- Update plugins: `:lua vim.pack.update()`, review the confirmation buffer, `:write` to apply, then commit the lockfile.
- Add a plugin: append it to `vim.pack.add()` and restart. Remove one: delete it from the list, then `:lua vim.pack.del({ "name" })`.
- New machine: the first launch installs the pinned revisions from the lockfile.

`plan.nvim` comes from the `plan` flake input (installed by Home Manager into the `nix` pack) so it stays in step with the CLI.

Language servers and formatters come from each project's dev shell; servers that are not on `PATH` are skipped. Only `tree-sitter` (for building parsers) is installed globally. This repository's dev shell (`.envrc`, `nix develop`) provides lua-language-server, stylua, nixd, and alejandra.

## Shell tools

`tldr` is supplied by Tealdeer, which refreshes its cache on use. Ghostty installs terminfo during interactive SSH connections; `,ssh-init-term <host>` remains available for other terminals. `,gc` collects Nix garbage, stopped Docker containers, and unused images. It does not remove Home Manager generations or Docker volumes.

Git uses `nvim --clean` for commit messages. Normal editing uses the full Neovim configuration.

## macOS settings

`./script/bootstrap` applies `script/macos` separately from Home Manager. It configures system preferences and restarts the affected UI processes; it is not part of `update.sh`.

## References

- [Home Manager manual](https://nix-community.github.io/home-manager/)
- [vim.pack](https://neovim.io/doc/user/pack.html#vim.pack)
- [Ghostty SSH integration](https://ghostty.org/docs/features/ssh)
- [Tealdeer](https://tealdeer-rs.github.io/tealdeer/)
