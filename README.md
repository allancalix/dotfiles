# Dotfiles

Just some dotfiles, designed to adhere to the XDG standard where possible.

## Requirements

1. Neovim 0.5+, required for some plugin features.

2. Fish! It's a shell with nice built in features. Some config functions use
   features that require Fish >= 3.2.0.

   [fish_add_path](https://fishshell.com/docs/current/relnotes.html?highlight=fish_add_path#fish-3-2-0-released-march-1-2021)

## Synchronizing

I use Ansible to automate synchronizing and deploying these dotfiles to my
development machines. You can see the details of how that happens [here](https://github.com/allancalix/devmachine).
The `exclude.txt` file specifies targets to not synchronize to the home directory (e.g. the git directory).

You can synchronize the dotfiles from here using the following command:

```bash
rsync -vr \
  --exclude-from=exclude.txt \
  . $HOME
```
