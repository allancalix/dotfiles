-- Plugins are managed by vim.pack and pinned in nvim-pack-lock.json (checked in next to init.lua).
--   :lua vim.pack.update()       review and apply updates (writes the lockfile)
--   :lua vim.pack.del({ "x" })   remove a plugin after deleting it from the list below
-- plan.nvim is installed by Home Manager from the plan flake input (pack/nix/start/plan).

-- Rebuild treesitter parsers whenever nvim-treesitter is installed or updated. Must be
-- registered before vim.pack.add() so it also fires on first install.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local data = ev.data
    if data.spec.name == "nvim-treesitter" and data.kind ~= "delete" then
      if not data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      require("nvim-treesitter").update()
    end
  end,
})

local function gh(repo) return "https://github.com/" .. repo end

vim.pack.add({
  gh("folke/tokyonight.nvim"),
  gh("nvim-mini/mini.icons"),
  { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },
  gh("neovim/nvim-lspconfig"), -- server definitions only (lsp/*.lua); enabled in config/lsp.lua
  gh("folke/snacks.nvim"),
  gh("folke/which-key.nvim"),
  gh("lewis6991/gitsigns.nvim"),
  gh("stevearc/conform.nvim"),
  gh("stevearc/oil.nvim"),
  gh("sindrets/diffview.nvim"),
  gh("yannvanhalewyn/jujutsu.nvim"),
  gh("preservim/vim-pencil"),
})

-- Colorscheme ---------------------------------------------------------------------------------
require("tokyonight").setup({
  transparent = true,
  styles = { sidebars = "transparent", floats = "transparent" },
})
vim.cmd.colorscheme("tokyonight")

-- Icons (also stands in for nvim-web-devicons for oil and diffview) ----------------------------
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

-- Treesitter ----------------------------------------------------------------------------------
-- Highlighting, folds, and indent are native; nvim-treesitter (main) only installs parsers and
-- ships queries. install() skips parsers that are already present.
require("nvim-treesitter").install({
  "bash",
  "diff",
  "fish",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "nickel",
  "nix",
  "query",
  "regex",
  "toml",
  "vim",
  "vimdoc",
  "yaml",
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
  callback = function(ev)
    if not pcall(vim.treesitter.start, ev.buf) then
      return
    end
    vim.wo[0][0].foldmethod = "expr"
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    if vim.treesitter.query.get(vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype), "indents") then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Snacks: picker, vim.ui.input/select, zen, and a few editor niceties ----------------------------
require("snacks").setup({
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  input = { enabled = true },
  picker = { enabled = true, ui_select = true },
  indent = { enabled = true },
  words = { enabled = true },
  zen = {
    on_open = function() vim.bo.autocomplete = false end,
    on_close = function() vim.cmd("setlocal autocomplete<") end,
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
})

-- which-key -------------------------------------------------------------------------------------
require("which-key").setup({
  preset = "helix",
  spec = {
    { "<leader>b", group = "buffer" },
    { "<leader>c", group = "code" },
    { "<leader>d", group = "diff" },
    { "<leader>f", group = "file/find" },
    { "<leader>g", group = "git" },
    { "<leader>gh", group = "hunks" },
    { "<leader>s", group = "search" },
    { "<leader>u", group = "ui/toggle" },
    { "<leader>x", group = "diagnostics/quickfix" },
    { "<leader><tab>", group = "tabs" },
    { "[", group = "prev" },
    { "]", group = "next" },
    { "g", group = "goto" },
  },
})

-- Git -----------------------------------------------------------------------------------------
require("gitsigns").setup({
  on_attach = function(buf)
    local gs = require("gitsigns")
    local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc }) end
    -- stylua: ignore start
    map("n", "]h", function() if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end end, "Next hunk")
    map("n", "[h", function() if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end end, "Prev hunk")
    map("n", "]H", function() gs.nav_hunk("last") end, "Last hunk")
    map("n", "[H", function() gs.nav_hunk("first") end, "First hunk")
    map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<cr>", "Stage hunk")
    map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<cr>", "Reset hunk")
    map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
    map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
    map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview hunk inline")
    map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame line")
    map("n", "<leader>ghB", gs.blame, "Blame buffer")
    map("n", "<leader>ghd", gs.diffthis, "Diff this")
    map({ "o", "x" }, "ih", ":<C-u>Gitsigns select_hunk<cr>", "Select hunk")
    -- stylua: ignore end
  end,
})

require("jujutsu-nvim").setup({ diff_preset = "diffview" })

-- Formatting ----------------------------------------------------------------------------------
-- Format on save; toggle globally with <leader>uf or per buffer with <leader>uF.
require("conform").setup({
  formatters_by_ft = {
    fish = { "fish_indent" },
    go = { "goimports", "gofumpt" },
    lua = { "stylua" },
    nix = { "alejandra" },
    sh = { "shfmt" },
  },
  default_format_opts = { lsp_format = "fallback" },
  format_on_save = function(buf)
    if vim.g.autoformat == false or vim.b[buf].autoformat == false then
      return
    end
    return { timeout_ms = 1000 }
  end,
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

-- Files ---------------------------------------------------------------------------------------
require("oil").setup()

-- Prose ---------------------------------------------------------------------------------------
vim.g["pencil#wrapModeDefault"] = "soft"
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_pencil", { clear = true }),
  pattern = { "markdown", "text", "rst", "plan" },
  callback = function() vim.fn["pencil#init"]() end,
})

-- plan.nvim (from Home Manager) -----------------------------------------------------------------
local ok, plan = pcall(require, "plan")
if ok then
  plan.setup({})
end
