function gh::go() {
  if [[ -z "$GITHUB_ROOT" ]]; then
    echo "GITHUB_ROOT environment variable is not set."
    return
  fi

  local target="${GITHUB_ROOT}/${@}"
  if [[ ! -d "$target" ]]; then
    echo "Repository ${target} not found."
    return
  fi

  cd "$target"
}
