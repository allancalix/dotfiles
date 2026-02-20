return {
  "sindrets/diffview.nvim",
  keys = {
    {
      "<leader>do",
      function()
        if vim.fn.isdirectory(vim.fn.finddir(".jj", ".;")) == 1 then
          vim.cmd("JJ log")
        else
          vim.cmd("DiffviewOpen")
        end
      end,
      desc = "Open Diffview",
    },
    { "<leader>dq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
  },
}
