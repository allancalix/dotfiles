local opt = vim.opt

-- Built-in plugins this config replaces or never uses.
for _, plugin in ipairs({ "gzip", "matchit", "matchparen", "netrw", "netrwPlugin", "tarPlugin", "tutor", "zipPlugin" }) do
  vim.g["loaded_" .. plugin] = 1
end

-- Remote plugin providers (Home Manager builds Neovim without them).
for _, provider in ipairs({ "node", "perl", "python3", "ruby" }) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

opt.swapfile = false
opt.undofile = true
opt.undolevels = 10000
opt.autowrite = true
opt.confirm = true
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
opt.mouse = "a"

-- Editing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.shiftround = true
opt.smartindent = true
opt.textwidth = 120
opt.formatoptions = "jcroqlnt"
opt.virtualedit = "block"
opt.spelllang = { "en" }

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit"
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.laststatus = 3
opt.list = true
opt.wrap = false
opt.linebreak = true
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.smoothscroll = true
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"
opt.winminwidth = 5
opt.conceallevel = 2
opt.pumheight = 10
opt.wildmode = "longest:full,full"
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.jumpoptions = "view"
opt.timeoutlen = 300
opt.updatetime = 200
opt.fillchars = { foldopen = "", foldclose = "", fold = " ", foldsep = " ", diff = "╱", eob = " " }
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

-- Folding: treesitter sets foldexpr per buffer (see config/plugins.lua); start unfolded.
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = ""

-- Native completion: pop up as you type from buffer words and, once an LSP attaches, its
-- omnifunc ('o'). Special buffers (pickers, prompts) are opted out in config/autocmds.lua.
opt.autocomplete = true
opt.complete:append("o")
opt.completeopt = "menu,menuone,noselect,popup"

vim.g.markdown_recommended_style = 0

-- Experimental 0.12 message/cmdline UI.
require("vim._core.ui2").enable({})
