export ZSH=$HOME/.oh-my-zsh
CUST_ZSH=$HOME/.zsh
ZSH_THEME="spaceship"

source $ZSH/oh-my-zsh.sh

source "$CUST_ZSH/options.sh"
source "$CUST_ZSH/completion.sh"
source "$CUST_ZSH/aliases.sh"
source "$CUST_ZSH/git.sh"
# source "$ZSH/themes/$ZSH_THEME.zsh-theme"

# Env vars
if [ $(uname -s) = 'Darwin' ]; then
  export PATH="$HOME/bin:/usr/local/bin:$PATH"
else
  export PATH="$HOME/bin:/$HOME/bin/cargo:$HOME/bin/go:usr/local/bin:$PATH"
fi

export NVM_DIR="$HOME/.nvm"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

