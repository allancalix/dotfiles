-- Server definitions come from nvim-lspconfig's lsp/*.lua; settings here are merged on top.
-- Binaries are expected on PATH from the project's dev shell. Servers whose command isn't
-- installed are skipped silently (see :checkhealth vim.lsp).

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = { test = true },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      usePlaceholders = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      semanticTokens = true,
    },
  },
})

vim.lsp.config("lua_ls", {
  -- Outside projects with their own .luarc.json, assume Neovim Lua (this config, plugins).
  on_init = function(client)
    local root = client.workspace_folders and client.workspace_folders[1] and client.workspace_folders[1].name
    if root and (vim.uv.fs_stat(root .. "/.luarc.json") or vim.uv.fs_stat(root .. "/.luarc.jsonc")) then
      return
    end
    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
      runtime = { version = "LuaJIT", path = { "lua/?.lua", "lua/?/init.lua" } },
      workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" } },
    })
  end,
  settings = {
    Lua = {
      completion = { callSnippet = "Replace" },
      hint = { enable = true },
      -- .direnv holds symlinks into /nix/store; scanning it makes lua_ls index the world.
      workspace = { ignoreDir = { ".direnv", ".jj", ".git", "node_modules", "result" } },
    },
  },
})

vim.lsp.enable({ "gopls", "lua_ls", "nickel_ls", "nixd" })

vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
  float = { border = "rounded", source = "if_many" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
})

-- Neovim's defaults already map K (hover), grn (rename), gra (code action), grr (references),
-- gri (implementation), grt (type definition), gO (symbols), <C-s> (signature help, insert),
-- and ]d/[d. These route goto/references through the snacks picker and add LazyVim-style
-- <leader>c bindings.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    local buf = ev.buf
    local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc }) end

    -- stylua: ignore start
    map("n", "gd", function() Snacks.picker.lsp_definitions() end, "Goto definition")
    map("n", "gD", function() Snacks.picker.lsp_declarations() end, "Goto declaration")
    map("n", "grr", function() Snacks.picker.lsp_references() end, "References")
    map("n", "gri", function() Snacks.picker.lsp_implementations() end, "Goto implementation")
    map("n", "grt", function() Snacks.picker.lsp_type_definitions() end, "Goto type definition")
    map("n", "gK", vim.lsp.buf.signature_help, "Signature help")
    map("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, "LSP symbols")
    map("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, "LSP workspace symbols")
    map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>cA", function() vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } }) end, "Source action")
    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
    map("n", "<leader>cR", function() Snacks.rename.rename_file() end, "Rename file")
    map({ "n", "x" }, "<leader>cc", vim.lsp.codelens.run, "Run codelens")
    map("n", "<leader>cl", "<cmd>checkhealth vim.lsp<cr>", "LSP info")
    -- stylua: ignore end

    if client:supports_method("textDocument/inlayHint", buf) then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end
  end,
})
