if type hub >/dev/null; then
  alias git=hub
  if type compdef >/dev/null 2>/dev/null; then
     compdef hub=git
  fi
fi

s() {
  git status -sb "$@"
  return 0
}

alias d='gd $argv'

alias ga='git add -A'
alias gap='ga -p'
alias gau='git add -u'
alias gbr='git branch -v'
alias gc!='git commit -v'
gc() {
    git diff --cached | rg '^<{7}$|^>{7}$|^={7}$' >/dev/null &&
      echo "\e[0;31;29mOops, you left merge commit errors in you doof.\e[0m" ||
    git commit -v "$@"
}
gca() {
  (git diff; git diff --cached) | rg '^<{7}$|^>{7}$|^={7}$' >/dev/null &&
    echo "\e[0;31;29mOops, you left merge commit errors in you doof.\e[0m" ||
    git commit -v -a "$@"
}
alias gcam='gca --amend'
alias gch='git cherry-pick'
alias gcm='git commit -v --amend'
alias gco='git checkout'
alias gcop='gco -p'
alias gd='git diff -M'
alias gdf='git diff --name-only'
alias gd.='git diff -M --color-words="."'
alias gdw='git diff -M --color-words="\w+"'
alias gdc='git diff --cached -M'
alias gdc.='git diff --cached -M --color-words="."'
alias gdcw='git diff --cached -M --color-words="\w+"'
alias gf='git fetch --prune'
git-new() {
  [ -d "$1" ] || mkdir "$1" &&
  cd "$1" &&
  git init &&
  touch .gitignore &&
  git add .gitignore &&
  git commit -m "Add .gitignore."
}
git_current_branch() {
  cat "$(git rev-parse --git-dir 2>/dev/null)/HEAD" | sed -e 's/^.*refs\/heads\///'
}
alias glog='git log --date-order --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(dim white) %an, %ar%Creset"'
alias gl='git lg'
alias gla='gl --all'
alias glo='gl HEAD origin/$(git_current_branch)'
gls() {
  query="$1"
  shift
  glog --pickaxe-regex "-S$query" "$@"
}
alias gm='git merge --no-ff'
alias gmf='git merge --ff-only'
alias gmfthis='gmf origin/$(git_current_branch)'
alias gp='git push'
alias gpthis='gp origin $(git_current_branch):$(git_current_branch)'
alias gpthis!='gp --set-upstream origin $(git_current_branch):$(git_current_branch)'
alias gr='git reset'
alias grb='git rebase -p'
alias grbthis='grb origin/$(git_current_branch)'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grh='git reset --hard'
alias grp='gr --patch'
alias grsh='git reset --soft HEAD~'
alias grv='git remote -v'
alias gs='git so -M'
alias gs.='git show -M --color-words="."'
alias gsw='git show -M --color-words="\w+"'
alias gst='git stash'
alias gstp='git stash pop'
alias gup='git pull'
gupstation() {
  gup
  gf production
  gf staging
}

# fbr - checkout git branch (including remote branches)
gbrs() {
  local branches branch
  branches=$(git branch --all | rg -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
