if [ `uname` = 'Darwin' ]; then
  alias ls='ls -G'
  alias du='du -k -d 1 $argv'
else
  alias ls='ls --color=auto'
  alias du='du -k --max-depth=1 $argv'
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
fi

alias df='df -kh $argv'
alias l='ls'
alias ll='ls -lh'
alias la='ls -a'
alias lal='ls -lah'
alias less='less -R'

cd() {
  builtin cd "$@" && ls
}

p() {
  cd "$(find ~/code ~/projects -type d -maxdepth 3 -name .git | sed -e 's/\/\.git$//' | selecta)"
}
