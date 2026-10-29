-- Neovim 0.12+ configuration built on the native plugin manager (vim.pack), LSP client
-- (vim.lsp.config/enable), completion ('autocomplete'), and message UI (ui2).
vim.loader.enable()

vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

require("config.options")
require("config.plugins")
require("config.lsp")
require("config.keymaps")
require("config.autocmds")
