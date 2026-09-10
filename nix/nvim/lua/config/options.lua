vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

vim.opt.textwidth = 120

vim.o.autocomplete = true
-- Neovim sets omnifunc when an LSP attaches; use it as a native completion source.
vim.opt.complete:append("o")
require("vim._core.ui2").enable({})
