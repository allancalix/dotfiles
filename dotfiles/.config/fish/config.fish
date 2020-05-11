setenv VISUAL "nvim"
setenv EDITOR "nvim"
setenv GIT_EDITOR "nvim"
setenv TERMCOLOR "truecolor"
setenv PYENV_ROOT "$HOME/.pyenv"
set PATH $PATH $HOME/bin $HOME/.cargo/bin $PYENV_ROOT/bin $HOME/go/bin

set FISH_CONFIG_ROOT "$HOME/.config/fish"

source "$FISH_CONFIG_ROOT/aliases.fish"

# Switch to vi style line editing.
fish_vi_key_bindings

if command -v tmux >/dev/null
  abbr -a t 'tmux'
  abbr -a tst 'tmux switch -t'
  abbr -a tat 'tmux attach -t'
  abbr -a tks 'tmux kill-session -t'
end

if command -v exa >/dev/null
    abbr -a l 'exa'
    abbr -a ls 'exa'
    abbr -a ll 'exa -l'
    abbr -a lal 'exa -la'
else
    abbr -a l 'ls'
    abbr -a ll 'ls -l'
    abbr -a lal 'ls -la'
end

# Git Prompt
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set -g fish_prompt_pwd_dir_length 3

setenv FZF_DEFAULT_COMMAND "fd --type f"
setenv FZF_DEFAULT_OPTS "
  --color=fg:#cbccc6,bg:#1f2430,hl:#707a8c
  --color=fg+:#707a8c,bg+:#191e2a,hl+:#ffcc66
  --color=info:#73d0ff,prompt:#707a8c,pointer:#cbccc6
  --color=marker:#73d0ff,spinner:#73d0ff,header:#d4bfff
  --reverse
  --border
  --height=25%
"
fzf_key_bindings

function fish_prompt
    set_color brblack
    echo -n "["(date "+%H:%M")"] "
    set_color blue
    echo -n (hostname)
    if [ $PWD != $HOME ]
        set_color brblack
        echo -n ':'
        set_color yellow
        echo -n (basename $PWD)
    end
    set_color green
    printf '%s ' (__fish_git_prompt)
    set_color red
    echo -n '| '
    set_color normal
end

# Disable greeting prompt
function fish_greeting
end
