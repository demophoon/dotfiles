" vim:fdm=marker
" Britt Gresham's Vimrc
if has("unix")
    set rtp+=~/.vim/bundle/vundle/
elseif has("win32")
    set rtp+=~/vimfiles/bundle/vundle/
endif
call vundle#rc()

" Look and Feel {{{
" Basics / Misc {{{
set nocompatible
filetype off
set mouse=a
set history=100
set number
set scrolloff=5
set encoding=utf-8
set hidden
set noswapfile
set nobackup
set nowb
" }}}
" Tabbing and Spaces {{{
set ts=4 sts=4 sw=4 expandtab
set autoindent
" }}}
" Color Settings {{{
set t_Co=256
set hls
syntax enable
colorscheme smyck
set colorcolumn=80
highlight colorcolumn guibg=#000000 ctermbg=246
" }}}
" GVIM Settings {{{
if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 10
  elseif has("gui_win32")
    set guifont=Consolas:h10:cANSI
  endif
endif
" }}}
" }}}
 
" Vundle Bundles {{{
Bundle 'gmarik/vundle'

Bundle 'Lokaltog/vim-powerline'
Bundle 'Valloric/YouCompleteMe'
Bundle 'dhazel/conque-term'
Bundle 'godlygeek/tabular'
Bundle 'mattn/zencoding-vim'
Bundle 'scrooloose/nerdtree'
Bundle 'skammer/vim-css-color'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-speeddating'
Bundle 'tpope/vim-surround'
Bundle 'vim-scripts/AutoClose'

Bundle 'msanders/snipmate.vim'
Bundle 'scrooloose/snipmate-snippets'

filetype plugin indent on
" }}}
" Plugin Settings {{{
" Powerline Settings {{{
" let g:Powerline_symbols = 'fancy'
set laststatus=2
" }}}
" }}}

" Mappings {{{
" Disable Arrows {{{
nmap <Left> <Esc>
nmap <Up> <Esc>
nmap <Right> <Esc>
nmap <Down> <Esc>
imap <Left> <Esc><Esc>a
imap <Up> <Esc><Esc>a
imap <Right> <Esc><Esc>a
imap <Down> <Esc><Esc>a
" }}}
" Easy Window Switching {{{
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" }}}
" Chrome Tab Navigation {{{
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
" Map C-n to C-f for Finish Word {{{
imap <C-f> <C-n>
imap <C-d> <C-p>
" }}}
" Space folds and unfolds {{{
nmap <Space> za
" }}}
" Zencoding {{{
let g:user_zen_leader_key='<c-e>'
let g:use_zen_complete_tag = 1
" }}}
" Misc {{{
imap jj <Esc>
" }}}
" }}}
" Vimrc Reload {{{
if has("autocmd")
    autocmd bufwritepost .vimrc source $MYVIMRC
endif
let mapleader = ","
nmap <leader>v :vs $MYVIMRC<CR>
" }}}
