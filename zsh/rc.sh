export ZSH=$HOME/.oh-my-zsh
export VISUAL="vim"
export EDITOR="$VISUAL"
export GIT_EDITOR="vim"

CUST_ZSH=$HOME/.zsh
ZSH_THEME="spaceship"

source $ZSH/oh-my-zsh.sh

source "$CUST_ZSH/options.sh"
source "$CUST_ZSH/completion.sh"
source "$CUST_ZSH/aliases.sh"
source "$CUST_ZSH/git.sh"

# Allow for different env variables depending on system
if [ $(uname -s) = 'Darwin' ]; then
  export PATH="$HOME/bin:/$HOME/bin/cargo:$HOME/bin/go:usr/local/bin:$PATH"
else
  export PATH="$HOME/bin:/$HOME/bin/cargo:$HOME/bin/go:usr/local/bin:$PATH"
fi

# Keybindings
bindkey -s '^f' 'fe\n'
bindkey -s '^e' 'cdf\n'

export NVM_DIR="$HOME/.nvm"
source $NVM_DIR/nvm.sh

export FZF_DEFAULT_COMMAND="rg --files --hidden -g '!.git/'"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

