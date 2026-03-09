return {
  "preservim/vim-pencil",
  ft = { "markdown", "text", "rst", "plan" },
  init = function()
    vim.g["pencil#wrapModeDefault"] = "soft"
  end,
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown", "text", "rst", "plan" },
      callback = function()
        vim.fn["pencil#init"]()
      end,
    })
  end,
}
