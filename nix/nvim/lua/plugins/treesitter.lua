local go_grammars = { "go", "gomod", "gowork", "gosum" }

return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      unpack(go_grammars),
      "nickel",
    },
  },
}
