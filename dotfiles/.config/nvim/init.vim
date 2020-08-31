set runtimepath+=~/.vim,~/.vim/after
set packpath+=~/.vim
source ~/.vimrc

lua <<EOF
require'nvim_lsp'.gopls.setup{}
EOF

