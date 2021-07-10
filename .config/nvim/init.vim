set runtimepath+=~/.vim,~/.vim/after
set packpath+=~/.vim
source ~/.vimrc

lua <<EOF
require'lspconfig'.gopls.setup{}
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.sourcekit.setup{}
require'lspconfig'.rescriptls.setup {
  cmd = {
    'node',
    '/usr/local/share/acx/pkg/third_party/rescript-vscode/extension/server/out/server.js',
    '--stdio',
  }
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
  },
}
EOF
