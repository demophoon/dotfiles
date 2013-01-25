call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Basics
set t_Co=256
set nocompatible
set mouse=a
set history=100
set number
set ts=4 sts=4 sw=4 expandtab
set scrolloff=5
set autoindent
set encoding=utf-8
set hidden
syntax enable
" set background=dark
" colorscheme solarized
" colorscheme codeschool
colorscheme smyck
set colorcolumn=80
highlight colorcolumn ctermbg=233

set noswapfile
set nobackup
set nowb

if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 11
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
endif

" Disable Arrows
nmap <Left> <Esc>
nmap <Up> <Esc>
nmap <Right> <Esc>
nmap <Down> <Esc>
imap <Left> <Esc><Esc>a
imap <Up> <Esc><Esc>a
imap <Right> <Esc><Esc>a
imap <Down> <Esc><Esc>a

" Folding Quickly open and close Folds with Spacebar
nnoremap <Space> za

" Exit Insert Mode with jj
imap jj <Esc>

" ZenCoding Mapped to <C-e> instead of <C-y>
" let g:user_zen_expandabbr_key='<c-e>'
let g:user_zen_leader_key='<c-e>'
let g:use_zen_complete_tag = 1

" let g:Powerline_symbols = 'fancy'
set laststatus=2

if has("autocmd")
    autocmd bufwritepost .vimrc source $MYVIMRC
endif

let mapleader = ","
nmap <leader>v :vsp $MYVIMRC<CR>

" If Mac Running
if (match(system("uname -s"), "Darwin") != -1)
    colorscheme macscheme
    set transparency=10
endif

