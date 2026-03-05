return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    dashboard = { enabled = false },
    explorer = { enabled = false },
    zen = {
      toggles = {
        dim = true,
        git_signs = false,
        mini_diff_signs = false,
        diagnostics = false,
        inlay_hints = false,
      },
      win = {
        style = "zen",
        width = 89,
        backdrop = { transparent = true, blend = 60 },
        wo = {
          wrap = true,
          linebreak = true,
          number = false,
          relativenumber = false,
          signcolumn = "no",
          spell = true,
          cursorline = false,
        },
      },
    },
  },
}
