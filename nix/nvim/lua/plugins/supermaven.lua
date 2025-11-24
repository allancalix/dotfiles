return {
  {
    "supermaven-inc/supermaven-nvim",
    cmd = {
      "SupermavenUsePro",
    },
    config = function()
      require("supermaven-nvim").setup({})
    end,
    opts = {
      keymaps = {
        accept_suggestion = nil, -- handled by nvim-cmp / blink.cmp
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
      disable_inline_completion = vim.g.ai_cmp,
      disable_keymaps = false, -- disables built in keymaps for more manual control
      ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
    },
  },
  "saghen/blink.compat",
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "supermaven-nvim", "saghen/blink.compat" },
    opts = {
      sources = {
        compat = { "supermaven" },
        providers = {
          supermaven = {
            kind = "Supermaven",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
}
