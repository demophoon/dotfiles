" vim: set foldenable, foldmethod=marker, foldlevel=0
" Britt Gresham's Vimrc

" Initialization {{{1
if has("unix")
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()
elseif has("win32")
    set rtp+=~/vimfiles/bundle/vundle/
    call vundle#rc("~/vimfiles/bundle")
endif
" }}}
" Look and Feel {{{1
" Basics / Misc {{{2
set nocompatible
filetype off
set backspace=2
set mouse=a
set history=100
set number
set scrolloff=5
set encoding=utf-8
set hidden
set noswapfile
set nobackup
set nowb
set lazyredraw
" }}}
" Tabbing and Spaces {{{2
set ts=4 sts=4 sw=4 expandtab
set autoindent
" }}}
" Color Settings {{{2
set t_Co=256
set hls
syntax enable
colorscheme smyck
set colorcolumn=80
highlight colorcolumn guibg=#000000 ctermbg=246
" }}}
" Persistent Undo {{{2
set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set undoreload=10000
" }}}
" GVIM Settings {{{2
if has("gui_running")
    if has("gui_gtk2")
        set guifont=Inconsolata\ 10
    elseif has("gui_win32")
        set guifont=Consolas:h10:cANSI
    endif
endif
" }}}
" Spelling / Typos {{{2
:command WQ wq
:command Wq wq
:command W w
:command Q q
" }}}
" }}}
" Vundle Bundles {{{1
Bundle 'gmarik/vundle'

Bundle 'Lokaltog/vim-powerline'
Bundle 'Valloric/YouCompleteMe'
Bundle 'dhazel/conque-term'
Bundle 'godlygeek/tabular'
Bundle 'mattn/zencoding-vim'
Bundle 'msanders/snipmate.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'skammer/vim-css-color'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-speeddating'
Bundle 'tpope/vim-surround'
Bundle 'vim-scripts/AutoClose'

filetype plugin indent on
" }}}
" Plugin Settings {{{1
" Powerline Settings {{{2
" let g:Powerline_symbols = 'fancy'
set laststatus=2
" }}}
" }}}
" Mappings {{{1
" Disable Arrows {{{2
nmap <Left> <Esc>
nmap <Up> <Esc>
nmap <Right> <Esc>
nmap <Down> <Esc>
imap <Left> <Esc><Esc>a
imap <Up> <Esc><Esc>a
imap <Right> <Esc><Esc>a
imap <Down> <Esc><Esc>a
" }}}
" Easy Window Switching {{{2
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" }}}
" Chrome Tab Navigation {{{2
nmap <C-S-]> gt
nmap <C-S-[> gT
nmap <C-1> 1gt
nmap <C-2> 2gt
nmap <C-3> 3gt
nmap <C-4> 4gt
nmap <C-5> 5gt
nmap <C-6> 6gt
nmap <C-7> 7gt
nmap <C-8> 8gt
nmap <C-9> 9gt
nmap <C-0> :tablast<CR>
"}}}
" Map C-n to C-f for Finish Word {{{2
imap <C-f> <C-n>
imap <C-d> <C-p>
" }}}
" Space folds and unfolds {{{2
nmap <Space> za
" }}}
" Zencoding {{{2
let g:user_zen_leader_key='<c-e>'
let g:use_zen_complete_tag = 1
" }}}
" Misc {{{2
imap jj <Esc>
" }}}
" }}}
" Vimrc Reload {{{1
if has("autocmd")
    autocmd bufwritepost .vimrc source $MYVIMRC
endif
let mapleader = ","
nmap <leader>v :vs $MYVIMRC<CR>
" }}}

