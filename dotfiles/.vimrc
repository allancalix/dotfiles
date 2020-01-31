if &compatible
  set nocompatible
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

command! PackInit packadd minpac | source $MYVIMRC | call minpac#update('', { 'do': 'quit'})
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('')
command! PackClean packadd minpac | source $MYVIMRC | call minpac#clean('')

if exists('*minpac#init')
  call minpac#init()

  " LSP
  call minpac#add('autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': {-> system('bash install.sh')} })

  " COMPLETION
  call minpac#add('ncm2/ncm2')
  call minpac#add('roxma/nvim-yarp')

  " RUST PLUGINS
  call minpac#add('rust-lang/rust.vim')

  " GENERIC FORMATTER
  call minpac#add('google/vim-maktaba')
  call minpac#add('google/vim-codefmt')

  " VUE PLUGINS
  call minpac#add('posva/vim-vue')

  " Terraform Plugins
  call minpac#add('hashivim/vim-terraform')

  " GENERAL PLUGINS
  call minpac#add('tomtom/tcomment_vim')
  call minpac#add('tpope/vim-surround')
  call minpac#add('bronson/vim-trailing-whitespace')
  call minpac#add('junegunn/seoul256.vim')
  call minpac#add('junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'})
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('itchyny/lightline.vim')
  call minpac#add('godlygeek/tabular')
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                   SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LSP
set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'go': ['gopls'],
    \ }

" COMPLETION CONFIGURATION
autocmd BufEnter * call ncm2#enable_for_buffer()
set shortmess+=c

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

let g:rustc_path = "/Users/allancalix/.cargo/bin/rustc"
let g:rustfmt_command = "/Users/allancalix/.cargo/bin/rustfmt"
" COMPLETION CONFIGURATION END
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
let g:seoul256_background = 235
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
