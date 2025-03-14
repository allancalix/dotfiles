vim.cmd[[colorscheme tokyonight]]
vim.cmd[[autocmd BufNewFile,BufRead *.ncl setfiletype nickel]]
-- Experimental (as of 0.9) Neovim lua loader, may speed up start times and replace `impatient-nvim`.
vim.loader.enable()

options = {theme = "base16"}

require("lualine").setup{
  options = options,
}
require("oil").setup()

local nvim_lsp = require("lspconfig")

require("supermaven-nvim").setup({
    keymaps = {
    accept_suggestion = "<Tab>",
    clear_suggestion = "<C-]>",
    accept_word = "<C-j>",
  },
  ignore_filetypes = { cpp = true },
  color = {
    suggestion_color = "#ffffff",
    cterm = 244,
  },
  disable_inline_completion = false, -- disables inline completion for use with cmp
  disable_keymaps = false -- disables built in keymaps for more manual control
})

local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "supermaven" },
    { name = "buffer" },
    { name = "path" },
  }),
})

-- START keybindings
-- Write out current buffer
vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", { noremap=true, silent=true })
-- Fast exit
vim.api.nvim_set_keymap("n", "<leader>q", ":qa!<CR>", { noremap=true, silent=true })
-- END   keybindings

-- START hop
local hop = require("hop")
local directions = require("hop.hint").HintDirection

vim.keymap.set("", "f", function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set("", "F", function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set("", "t", function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, {remap=true})
vim.keymap.set("", "T", function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, {remap=true})
vim.keymap.set("", " ", function()
  hop.hint_patterns()
end, {remap=true})

hop.setup({ keys = "etovxqpdygfblzhckisuran" })
-- END hop

local previewers = require("telescope.previewers")
local actions = require("telescope.actions")

local limited_preview = function(filepath, bufnr, opts)
  opts = opts or {}

  filepath = vim.fn.expand(filepath)
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat then return end
    if stat.size > 100000 then
      return
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end

local binary_filter = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath)
  Job:new({
    command = "file",
    args = { "--mime-type", "-b", filepath },
    on_exit = function(j)
      local mime_type = vim.split(j:result()[1], "/")[1]
      if mime_type == "text" then
        limited_preview(filepath, bufnr, opts)
      else
        -- maybe we want to write something to the buffer here
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
        end)
      end
    end
  }):sync()
end

require("telescope").setup {
  buffer_preview_maker = binary_filter,
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-u>"] = false,
      },
    },
    vimgrep_arguments = {
      "rg",
      "--vimgrep",
      "--no-heading",
      "--smart-case",

      "--ignore",
      "--hidden",
      "--trim",
    },
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
    },
  },
}
require("telescope").load_extension("zf-native")

-- Workspace base navigation
vim.api.nvim_set_keymap("", "<Leader>fe", "<cmd>:Oil<cr>", {})
vim.api.nvim_set_keymap("", "<Leader>fr", "<cmd>:Telescope live_grep prompt_prefix=🔍<cr>", {})
vim.api.nvim_set_keymap("", "<Leader>fb", "<cmd>:Telescope buffers prompt_prefix=🔍<cr>", {})
vim.api.nvim_set_keymap("", "<Leader>fm", '<cmd>lua require("telescope.builtin").marks()<cr>', {})
vim.api.nvim_set_keymap("", "<Leader>ff", '<cmd>lua require("telescope.builtin").git_files(require("telescope.themes").get_dropdown({ previewer = false }))<cr>', {})
vim.api.nvim_set_keymap("", "<Leader>fg", '<cmd>lua require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({ previewer = false }))<cr>', {})
vim.api.nvim_set_keymap("", "<Leader>fw", '<cmd>lua require("telescope.builtin").lsp_workspace_symbols()<cr>', {})
vim.api.nvim_set_keymap("", "<Leader>gb", '<cmd>lua require("telescope.builtin").git_branches()<cr>', {})

require"nvim-treesitter.configs".setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting=false,
  },
  ident = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- Code based navigation
  buf_set_keymap("", "<Leader>cs", '<cmd>lua require("telescope.builtin").lsp_document_symbols(require("telescope.themes").get_dropdown({}))<cr>', {})
  buf_set_keymap("", "<Leader>cr", '<cmd>lua require("telescope.builtin").lsp_references(require("telescope.themes").get_dropdown({}))<cr>', {})

  buf_set_keymap("", "<Leader>ci", '<cmd>lua require("telescope.builtin").lsp_implementations(require("telescope.themes").get_dropdown({}))<cr>', {})
  buf_set_keymap("", "<Leader>ct", '<cmd>lua require("telescope.builtin").lsp_type_definitions(require("telescope.themes").get_dropdown({}))<cr>', {})

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<Leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<Leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<Leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<Leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<Leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<Leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<Leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Use a loop to conveniently call "setup" on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "rust_analyzer", "gopls", "zls", "nickel_ls", "clojure_lsp", "sourcekit" }
local capabilities = require("cmp_nvim_lsp").default_capabilities()
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup ({
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  })

end

require("conform").setup({
  -- Map of filetype to formatters
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    go = { "goimports", "gofmt" },
    -- You can also customize some of the format options for the filetype
    rust = { "rustfmt", lsp_format = "fallback" },
  },

  format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 500,
  },
})

