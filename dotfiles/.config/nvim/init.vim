set runtimepath+=~/.vim,~/.vim/after
set packpath+=~/.vim
source ~/.vimrc

lua <<EOF
require'lspconfig'.gopls.setup{}
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.sourcekit.setup{}

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
  },
}

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
  };
}
vim.o.completeopt = "menuone,noselect"
EOF
