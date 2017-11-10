export ZSH=$HOME/.oh-my-zsh
export GIT_EDITOR="vim"
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

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
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

