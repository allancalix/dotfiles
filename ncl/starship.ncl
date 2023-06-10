{
  format =
    " "
    ++ std.string.join
      ""
      [
        "$username",
        "$hostname",
        "$directory",
        "$git_branch",
        "$git_state",
        "$git_status",
        "$cmd_duration",
        "$line_break",
        "$character",
      ],
  character = {
    success_symbol = "[❯](purple)",
    error_symbol = "[❯](red)",
    vimcmd_symbol = "[❮](green)",
  },
  cmd_duration = {
    format = "[$duration]($style) ",
    style = "yellow",
  },
  directory = {
    style = "blue",
  },
  git_branch = {
    format = "[$branch]($style)",
    style = "bright-black",
  },
  git_status = {
    format = "[[(•$untracked$modified$staged)](218) ($ahead_behind$stashed)]($style)",
    style = "cyan",
    untracked = " ",
    modified = " ",
    staged = " ",
    stashed = "≡",
  },
  git_state = {
    format = "\\([$state( $progress_current/$progress_total)]($style)\\) ",
    style = "bright-black",
  },
}
