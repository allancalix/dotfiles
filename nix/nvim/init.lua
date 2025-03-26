vim.cmd([[noswapfile]])
vim.cmd([[source ~/.config/nvim/vimrc.vim]])

require("config.lazy")

vim.cmd([[autocmd BufNewFile,BufRead *.ncl setfiletype nickel]])
-- Experimental (as of 0.9) Neovim lua loader, may speed up start times and replace `impatient-nvim`.
vim.loader.enable()

require("oil").setup()

-- START keybindings
-- Write out current buffer
vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })
-- Fast exit
vim.api.nvim_set_keymap("n", "<leader>q", ":qa!<CR>", { noremap = true, silent = true })
-- END   keybindings

-- Workspace base navigation
vim.api.nvim_set_keymap("", "<Leader>fe", "<cmd>:Oil<cr>", {})
