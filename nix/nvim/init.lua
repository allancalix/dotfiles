options = {theme = 'ayu_mirage'}

require'ayu'.setup{
  mirage = true,
  overrides = {},
}

require'lualine'.setup{
  options = options,
}

local nvim_lsp = require('lspconfig')
local coq = require('coq')
require('coq_3p') {
  { src = "copilot", short_name = "COP", accept_key = "<C-f>" },
}

vim.api.nvim_set_keymap("n", "<Leader>mt", ":lua require('checklist').toggle_item()<CR>", { noremap = true, silent = true })

-- place this in one of your configuration file(s)
require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }

vim.api.nvim_set_keymap("", 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap("", 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap("", 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>", {})
vim.api.nvim_set_keymap("", 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>", {})

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

require'telescope'.setup {
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

-- Workspace base navigation
vim.api.nvim_set_keymap("", "<Leader>fr", "<cmd>:Telescope live_grep prompt_prefix=🔍<cr>", {})
vim.api.nvim_set_keymap("", "<Leader>fb", "<cmd>:Telescope buffers prompt_prefix=🔍<cr>", {})
vim.api.nvim_set_keymap("", "<Leader>fm", "<cmd>lua require('telescope.builtin').marks()<cr>", {})
vim.api.nvim_set_keymap("", "<Leader>ff", "<cmd>lua require('telescope.builtin').git_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", {})
vim.api.nvim_set_keymap("", "<Leader>fg", "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", {})
vim.api.nvim_set_keymap("", "<Leader>fw", "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>", {})

vim.api.nvim_set_keymap("", "<Leader>gb", "<cmd>lua require('telescope.builtin').git_branches()<cr>", {})

require'nvim-treesitter.configs'.setup {
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
  buf_set_keymap("", "<Leader>cs", "<cmd>lua require('telescope.builtin').lsp_document_symbols(require('telescope.themes').get_dropdown({}))<cr>", {})
  buf_set_keymap("", "<Leader>cr", "<cmd>lua require('telescope.builtin').lsp_references(require('telescope.themes').get_dropdown({}))<cr>", {})
  buf_set_keymap("", "<Leader>ci", "<cmd>lua require('telescope.builtin').lsp_implementations(require('telescope.themes').get_dropdown({}))<cr>", {})
  buf_set_keymap("", "<Leader>ct", "<cmd>lua require('telescope.builtin').lsp_type_definitions(require('telescope.themes').get_dropdown({}))<cr>", {})

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<Leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<Leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<Leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "rust_analyzer", "ocamllsp" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup (coq.lsp_ensure_capabilities({
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }))

require'lspconfig'.elixirls.setup (coq.lsp_ensure_capabilities({
  on_attach = on_attach,
  cmd = { "/Users/allancalix/acx/src/github.com/allancalix/dotfiles/elixir-lsp/language_server.sh" };
}))

end
