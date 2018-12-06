export VISUAL="nvim"
export EDITOR="$VISUAL"
export GIT_EDITOR="nvim"
export PYENV_ROOT="$HOME/.pyenv"
export NVM_DIR="$HOME/.nvm"

CUST_ZSH=$HOME/.zsh

source "$CUST_ZSH/options.sh"
source "$CUST_ZSH/completion.sh"
source "$CUST_ZSH/aliases.sh"
source "$CUST_ZSH/git.sh"
source "$CUST_ZSH/fzf.zsh"

# Allow for different env variables depending on system
if [ $(uname -s) = 'Darwin' ]; then
  export PATH="$HOME/.bin:$HOME/.cargo/.bin:/usr/local/bin:$PYENV_ROOT/bin:$PATH"
else
  export PATH="$HOME/.bin:$HOME/.cargo/.bin:/usr/local/bin:$PYENV_ROOT/bin:$PATH"
  # Add linux brew binaries to path
  export PATH='/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin':"$PATH"
fi

# Custom Keybindings
bindkey -s '^f' 'fe\n'
bindkey -s '^e' 'cdf\n'

source "$NVM_DIR/nvm.sh"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
