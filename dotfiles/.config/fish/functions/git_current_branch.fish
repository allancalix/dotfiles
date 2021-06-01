function git_current_branch
  set path (git rev-parse --git-dir 2>/dev/null)
  cat "$path/HEAD" | sed -e 's/^.*refs\/heads\///'
end
