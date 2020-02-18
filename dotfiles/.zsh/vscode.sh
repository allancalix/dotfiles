# VSCode annoyingly keeps config files in different locations depending on
# platform. Normalize config location and bootstrap with location.
function code::open() {
  local configs="${HOME}/.config/vscode/"
  code --user-data-dir="$configs" "$@"
}
