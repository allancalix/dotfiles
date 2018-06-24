if &compatible
  set nocompatible
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'quit'})
command! PackClean packadd minpac | source $MYVIMRC | call minpac#clean('', {'do': 'quit'})

if exists('*minpac#init')
  call minpac#init()

  call minpac#add('tomtom/tcomment_vim')
  call minpac#add('tpope/vim-surround')
  call minpac#add('tpope/vim-fugitive')
  call minpac#add('tpope/vim-unimpaired')
  call minpac#add('bronson/vim-trailing-whitespace')
  call minpac#add('altercation/vim-colors-solarized')
  call minpac#add('junegunn/seoul256.vim')
  call minpac#add('junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'})
  call minpac#add('junegunn/fzf.vim')
  call minpac#add('itchyny/lightline.vim')
  call minpac#add('sheerun/vim-polyglot')
  call minpac#add('w0rp/ale')
  call minpac#add('godlygeek/tabular')
  call minpac#add('SirVer/ultisnips')
  call minpac#add('honza/vim-snippets')
  call minpac#add('fatih/vim-go', {'type': 'opt'})

  if has('nvim')
    call minpac#add('Shougo/deoplete.nvim', {'do': 'UpdateRemotePlugins'})
    call minpac#add('zchee/deoplete-jedi')
    call minpac#add('zchee/deoplete-go', {'do': 'make'})
  endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                   SETTINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:deoplete#enable_at_startup = 1

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
set t_Co=256

" Range: 233-256. Default 237
let g:seoul256_background = 235
colo seoul256

" Editorconfig
command! -bang -nargs=* Find call fzf#vim#grep("rg --pretty --fixed-strings --ignore-case --no-heading -g '!.git/' ".shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)

"=================DEOPLETE==================
let g:deoplete#enable_at_startup = 1
set completeopt-=preview

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

" insert newline without entering insert mode
map <CR> o<Esc>k

" reloads .vimrc -- making all changes active
map <F1> <Esc>
imap <F1> <Esc>

" Leader C prefix is for code related mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

noremap <silent> <Leader>cc          :TComment<CR>              "tcomment_vim

" Hotkey for removing trailing whitespace in a file
noremap <silent> <Leader>cw          :%s/[ \t]*$//g<CR>

" Leader F prefix is for file related mappings (open, browse...)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> <Leader>f :Files<CR>
nnoremap <silent> <Leader>fe :Explore <CR>

" Leader B prefix is for buffer related mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> <Leader>bb :bn<CR>
nnoremap <silent> <Leader>bd :bdelete<CR>

" (un)lock the current buffer to prevent modification
nnoremap <silent> <Leader>bl :set nomodifiable<CR>
nnoremap <silent> <Leader>bu :set modifiable<CR>