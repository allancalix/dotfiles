if &compatible
  set nocompatible
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

set clipboard=unnamedplus
set number
set relativenumber

" GENERAL
set backspace=indent,eol,start
set ruler
set wildmenu
set autowrite
set autoread

" configure the invisible chars
set listchars=tab:>.,trail:.,extends:#,nbsp:.

set smartcase
set smarttab
set autoindent
set ignorecase

set backupdir=/tmp/vim
set directory=/tmp/vim

set textwidth=120
set nowrap
set colorcolumn=81
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

let g:netrw_banner = 0
let g:netrw_sort_sequence = '[\/]$,*'
let g:netrw_list_hide = '^bazel-.*$,^node_modules'
let g:netrw_hide = 1

" Keybindings
let mapleader = ','
inoremap jj <ESC>
inoremap <C-L> <ESC>
noremap <CR> o<Esc>k
noremap <silent> <Leader>cc :Commentary<CR>

lua << EOF
require'hop'.setup()

vim.api.nvim_set_keymap("", 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap("", 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap("", 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>", {})
vim.api.nvim_set_keymap("", 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>", {})
EOF

" Assume the environment is a pager if not being used a vscode buffer.
if !exists('g:vscode')
  set scrollback=100000

  map <silent> q :qa!<CR>

  augroup start_at_bottom
    autocmd!
    autocmd VimEnter * normal G
  augroup END

  augroup prevent_insert
      autocmd!
      autocmd TermEnter * stopinsert
  augroup END
endif
