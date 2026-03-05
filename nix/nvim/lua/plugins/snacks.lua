return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    dashboard = { enabled = false },
    explorer = { enabled = false },
    zen = {
      win = { style = "zen", width = 89 },
      on_open = function(win)
        vim.wo[win.win].wrap = true
        vim.wo[win.win].linebreak = true
        local buf = win.buf or vim.api.nvim_win_get_buf(win.win)
        vim.bo[buf].textwidth = 0
      end,
    },
  },
}
