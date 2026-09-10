return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gopls = {
        mason = false,
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
      },
    },
  },
}
