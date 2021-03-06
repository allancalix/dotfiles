export VISUAL="nvim"
export EDITOR="$VISUAL"
export GIT_EDITOR="nvim"
export PYENV_ROOT="$HOME/.pyenv"
export NVM_DIR="$HOME/.nvm"
export TERMCOLOR="truecolor"

CUST_ZSH=$HOME/.zsh

source "$CUST_ZSH/options.sh"
source "$CUST_ZSH/completion.sh"
source "$CUST_ZSH/aliases.sh"
source "$CUST_ZSH/git.sh"
source "$CUST_ZSH/fzf.zsh"
source "$CUST_ZSH/github.sh"

# Allow for different env variables depending on system
if [ $(uname -s) = 'Darwin' ]; then
  export PATH="$HOME/bin:$HOME/.cargo/bin:/usr/local/bin:$PYENV_ROOT/bin:$PATH"
  export PATH="$HOME/go/bin:$PATH"
else
  export PATH="$HOME/bin:$HOME/.cargo/bin:/usr/local/bin:$PYENV_ROOT/bin:$PATH"
  export PATH="$HOME/go/bin:$PATH"
fi

# Custom Keybindings
bindkey -s '^f' 'fe\n'
bindkey -s '^e' 'cdf\n'

source "$NVM_DIR/nvm.sh"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

if [[ -d ${HOME}/.cargo/env ]]; then
  source ${HOME}/.cargo/env
fi

if [[ -f ~/.zsh.local ]]; then
  . ~/.zsh.local
fi
