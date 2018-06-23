# Shell history
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=900000 # This value is smaller than HISTSIZE to allow a window for dupes.
setopt append_history # Append to the history file rather than replacing it.
setopt inc_append_history # Write history items as they are run, not on shell exit.
setopt hist_expire_dups_first # Expire duplicate history items before older unique ones.
setopt hist_ignore_dups # Don't save consecutive duplicate history items.

# Misc zsh config
setopt notify # Print background job status immediately.
unsetopt auto_cd # Don't "execute" directories by changing into them.
bindkey "^[[3~" delete-char # Forward-delete properly instead of echoing '~'.

# Move between (customised) words with option-left/right.
export WORDCHARS='*?[]~=&;!#$%^(){}'
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word

# fzf Options
_gen_fzf_default_opts() {
  # Solarized Dark color scheme for fzf
  local color00='#000000'
  local color01='#303030'
  local color02='#505050'
  local color03='#b0b0b0'
  local color04='#d0d0d0'
  local color05='#e0e0e0'
  local color06='#f5f5f5'
  local color07='#ffffff'
  local color08='#fb0120'
  local color09='#fc6d24'
  local color0A='#fda331'
  local color0B='#a1c659'
  local color0C='#76c7b7'
  local color0D='#6fb3d2'
  local color0E='#d381c3'
  local color0F='#be643c'

  export FZF_DEFAULT_OPTS="
    --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D
    --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C
    --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D
    --reverse
    --border
    --height=40%
  "
}
_gen_fzf_default_opts
