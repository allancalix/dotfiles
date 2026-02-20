return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    dashboard = { enabled = false },
    explorer = { enabled = false },
    zen = {
      win = { style = "zen" },
      on_open = function(win)
        vim.wo[win.win].wrap = true
        vim.wo[win.win].linebreak = true
        vim.wo[win.win].textwidth = 0
        win:resize({ width = 89 })
      end,
    },
  },
}
