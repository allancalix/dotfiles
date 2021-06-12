# Dotfiles

Two annoying parts of previous dotfiles directories were:

1. Minor changes on one system would add up into drift between environments.
2. Operations that were not idempotent caused me to not update my configurations
   in order to update my system. This also led to drift between environments.
   
Ansible playbooks are a useful tool for declaratively specifying the state of a system
and abstracting away how that state is reached. Also, I could make changes to multiple
systems simultaneously if I were so inclined.

## Prerequisites

1. Homebrew on Mac
2. [ansible-playbook](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## Per System Configuration

There are two ways you could make system specific changes at runtime. The first is to include
a `POST-INSTALL.sh` script in the repositories root directory. Any time the dotfiles directory
syncs, this script is executed.

An example might be:
```sh
# POST-INSTALL.sh
git config --global user.name "Jane Doe"
git config --global user.email "jane.doe@mailinator.com"
```
This script should try to remain idempotent as it could potentially be executed multiple times.

## Notes

* [VSCODE_EXTENSIONS](VSCODE_EXTENSIONS) can be used to ensure that vscode extensions are installed.

* [scripts/macos.sh](scripts/macos.sh)

    Sets system settings for mac. These are only run during fresh installs.
    Unless the `install` tag is explicitly set, this script won't run.

## Running Playbooks

From the repository root directory.

```sh
# Fresh install
DOTFILES_REPO=$PWD ansible-playbook --tags = all,install --ask-become-pass ansible/darwin.yaml

# System update (config and dependencies)
DOTFILES_REPO=$PWD ansible-playbook --ask-become-pass ansible/darwin.yaml

# Config update only
DOTFILES_REPO=$PWD ansible-playbook --tags = configuration --ask-become-pass ansible/darwin.yaml

# Syncs dotfiles only
DOTFILES_REPO=$PWD ansible-playbook --tags=sync ansible/darwin.yaml
```

## Some Good Dotfiles

* [Mathias Bynens](https://github.com/mathiasbynens/dotfiles)
