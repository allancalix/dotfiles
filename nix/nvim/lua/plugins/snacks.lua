return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    dashboard = { enabled = false },
    explorer = { enabled = false },
    zen = {
      on_open = function()
        vim.b.completion = false
        vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
      end,
      on_close = function()
        vim.b.completion = true
        vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
      end,
      toggles = {
        dim = true,
        git_signs = false,
        mini_diff_signs = false,
        diagnostics = false,
        inlay_hints = false,
      },
      win = {
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
          scrolloff = 999,
        },
      },
    },
  },
}
