if &compatible
  set nocompatible
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

call plug#begin('~/.config/nvim/plugins')
" LSP
Plug 'neovim/nvim-lspconfig'
" Plugins are installed through neovim to setup completion sources.
" * CocInstall coc-rust-analyzer
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" RUST PLUGINS
Plug 'rust-lang/rust.vim'

" Terraform Plugins
Plug 'hashivim/vim-terraform'

" GENERAL PLUGINS
Plug 'dag/vim-fish'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'bronson/vim-trailing-whitespace'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'godlygeek/tabular'

" Init Plugins
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                   SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LSP
set hidden

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:fzf_layout = { 'down': '~35%' }

" GENERAL
set backspace=indent,eol,start
set ruler
set wildmenu

set autowrite
set autoread

" SEARCH
set incsearch
set hlsearch
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" configure the invisible chars
set listchars=tab:>.,trail:.,extends:#,nbsp:.

set smartcase
set smarttab
set autoindent
set ignorecase

set backupdir=~/.vim/tmp/                   " for the backup files
set directory=~/.vim/tmp/                   " for the swap files

set textwidth=80
set colorcolumn=81
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" FILE EXPLORER
let g:netrw_banner = 0
let g:netrw_sort_sequence = '[\/]$,*'
let g:netrw_list_hide = '^bazel-.*$,^node_modules'
let g:netrw_hide = 1

:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

"==============LIGHTLINE=================

let g:lightline = {'colorscheme': 'seoul256',}
set laststatus=2
set noshowmode

"================THEMES==================
set t_Co=257

" Range: 233-256. Default 237
let g:seoul256_background = 234
silent! colo seoul256

" Editorconfig
command! -bang -nargs=* Find call fzf#vim#grep("rg --pretty --fixed-strings --ignore-case --no-heading -g '!.git/' -g '!target/'".shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

"=================TABULAR==================

" Align on equal sign
vnoremap <silent> <Leader>cee    :Tabularize /=<CR>              "tabular
" Align on # sign (comment)
vnoremap <silent> <Leader>cet    :Tabularize /#<CR>             "tabular
" Align (no sign)
vnoremap <silent> <Leader>ce     :Tabularize /

"==================KEYS====================
let mapleader = ','

" use jj to quickly escape to normal mode while typing <- AWESOME tip
inoremap jj <ESC>
inoremap <C-L> <ESC>

" insert newline without entering insert mode
map <CR> o<Esc>k

" reloads .vimrc -- making all changes active
map <F1> <Esc>
imap <F1> <Esc>

" Leader C prefix is for code related mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <F5> :call LanguageClient_contextMenu()<CR>
noremap <silent> <Leader>c? :call LanguageClient#textDocument_hover()<CR>
noremap <silent> <Leader>cd :call LanguageClient#textDocument_definition()<CR>
noremap <silent> <Leader>cr :call LanguageClient#textDocument_rename()<CR>

noremap <silent> <Leader>cc          :TComment<CR>              "tcomment_vim

" Hotkey for removing trailing whitespace in a file
noremap <silent> <Leader>cw          :%s/[ \t]*$//g<CR>

" Leader F prefix is for file related mappings (open, browse...)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command! LocalFiles call fzf#run(fzf#wrap(
  \{'source': "rg --files -g '!target/'", 'sink': 'e'}))
nnoremap <silent> <Leader>ff :LocalFiles<CR>
nnoremap <silent> <Leader>fe :Explore<CR>

" Leader B prefix is for buffer related mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> <Leader>bb :bn<CR>
nnoremap <silent> <Leader>bd :bdelete<CR>

" (un)lock the current buffer to prevent modification
nnoremap <silent> <Leader>bl :set nomodifiable<CR>
nnoremap <silent> <Leader>bu :set modifiable<CR>
