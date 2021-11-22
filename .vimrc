if &compatible
  set nocompatible
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

call plug#begin('~/.config/nvim/plugins')

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}

" dependencies
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
" telescope
Plug 'nvim-telescope/telescope.nvim'

Plug 'fatih/vim-go'
Plug 'rescript-lang/vim-rescript'
Plug 'jjo/vim-cue'

" GENERAL PLUGINS
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'bronson/vim-trailing-whitespace'
Plug 'ayu-theme/ayu-vim'
Plug 'hoob3rt/lualine.nvim'
Plug 'godlygeek/tabular'
Plug 'editorconfig/editorconfig-vim'

" Init Plugins
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                   SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LSP
set hidden

" GENERAL
set backspace=indent,eol,start
set ruler
set wildmenu

let g:coq_settings = { 'auto_start': 'shut-up', 'display.pum.fast_close': v:false }
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set autowrite
set autoread

" SEARCH
set inccommand=nosplit
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

:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

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

noremap <silent> <Leader>cc          :TComment<CR>              "tcomment_vim

" Hotkey for removing trailing whitespace in a file
noremap <silent> <Leader>cw          :%s/[ \t]*$//g<CR>

" Leader F prefix is for file related mappings (open, browse...)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --ignore\ --hidden
nnoremap <silent> <Leader>ff :Telescope find_files find_command=fd prompt_prefix=🔍<CR>
nnoremap <silent> <Leader>fg :Telescope git_files prompt_prefix=🔍<CR>
nnoremap <silent> <Leader>fr :Telescope live_grep prompt_prefix=🔍<CR>
nnoremap <silent> <Leader>fb :Telescope buffers prompt_prefix=🔍<CR>
nnoremap <silent> <Leader>fm :lua require'telescope.builtin'.marks{}<CR>
nnoremap <silent> <Leader>fd :lua require'telescope.builtin'.lsp_workspace_symbols{}<CR>
nnoremap <silent> <Leader>fe :Explore<CR>

nnoremap <silent> <Leader>cs :lua require'telescope.builtin'.lsp_document_symbols{}<CR>

" Leader B prefix is for buffer related mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> <Leader>bb :bn<CR>
nnoremap <silent> <Leader>bd :bdelete<CR>

" (un)lock the current buffer to prevent modification
nnoremap <silent> <Leader>bl :set nomodifiable<CR>
nnoremap <silent> <Leader>bu :set modifiable<CR>
