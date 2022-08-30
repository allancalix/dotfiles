if &compatible
  set nocompatible
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

set hidden
set clipboard=unnamedplus
set number
set relativenumber

" GENERAL
set backspace=indent,eol,start
set ruler
set wildmenu

let g:coq_settings = { 'auto_start': 'shut-up', 'display.pum.fast_close': v:false, 'xdg': v:true }
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set autowrite
set autoread

" SEARCH
set inccommand=nosplit
set incsearch
set hlsearch

" configure the invisible chars
set listchars=tab:>.,trail:.,extends:#,nbsp:.

set smartcase
set smarttab
set autoindent
set ignorecase

set backupdir=~/.vim/tmp/                   " for the backup files
set directory=~/.vim/tmp/                   " for the swap files

set textwidth=120
set nowrap " wrapping is really annoying when working with html/jsx files
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

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

"================THEMES==================
set termguicolors     " enable true colors support
let ayucolor="mirage" " light | mirage | dark
colorscheme ayu

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
noremap <silent> <Leader>cn :call LanguageClient#textDocument_rename()<CR>

noremap <silent> <Leader>cc          :Commentary<CR>

" Hotkey for removing trailing whitespace in a file
noremap <silent> <Leader>cw          :%s/[ \t]*$//g<CR>

" Leader F prefix is for file related mappings (open, browse...)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --ignore\ --hidden
nnoremap <silent> <Leader>fe :Explore<CR>

" Leader B prefix is for buffer related mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> <Leader>bb :bn<CR>
nnoremap <silent> <Leader>bd :bdelete<CR>

" (un)lock the current buffer to prevent modification
nnoremap <silent> <Leader>bl :set nomodifiable<CR>
nnoremap <silent> <Leader>bu :set modifiable<CR>
