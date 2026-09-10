vim.opt.swapfile = false

require("config.lazy")

vim.filetype.add({ extension = { ncl = "nickel" } })

-- Keybindings
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Write buffer" })
vim.keymap.set("n", "<leader>q", "<cmd>qa!<cr>", { desc = "Quit all" })
vim.keymap.set("n", "<leader>fe", "<cmd>Oil<cr>", { desc = "File explorer (Oil)" })
vim.keymap.set("i", "jj", "<esc>")
vim.keymap.set("n", "<leader>cw", [[<cmd>%s/[ \t]*$//g<cr>]], { desc = "Strip trailing whitespace" })
