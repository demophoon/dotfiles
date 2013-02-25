" vim:fdm=marker
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
"
" Look and Feel {{{
" Basics {{{
set t_Co=256
set nocompatible
set hls
set mouse=a
set history=100
set number
set ts=4 sts=4 sw=4 expandtab
set scrolloff=5
set autoindent
set encoding=utf-8
set hidden
syntax enable
set noswapfile
set nobackup
set nowb
colorscheme smyck
set colorcolumn=80
highlight colorcolumn guibg=#000000 ctermbg=246


if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 11
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
endif

" }}}
" Vundle Bundles {{{
Bundle 'gmarik/vundle'

Bundle 'Lokaltog/powerline'
Bundle 'Valloric/YouCompleteMe'
Bundle 'dhazel/conque-term'
Bundle 'godlygeek/tabular'
Bundle 'mattn/zencoding-vim'
Bundle 'scrooloose/nerdtree'
Bundle 'skammer/vim-css-color'
Bundle 'snipMate'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-speeddating'
Bundle 'tpope/vim-surround'
Bundle 'vim-scripts/AutoClose'

filetype plugin indent on

" }}}
" Mappings {{{

" Disable Arrows {{{
imap jj <Esc>
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

" Space folds and unfolds
nmap <Space> za

" ZenCoding Mapped to <C-e> instead of <C-y> {{{
let g:user_zen_leader_key='<c-e>'
let g:use_zen_complete_tag = 1
" }}}

" Misc {{{
let g:Powerline_symbols = 'fancy'
set laststatus=2
" }}}

" }}}
"Vimrc Reload {{{
if has("autocmd")
    autocmd bufwritepost .vimrc source $MYVIMRC
    colorscheme smyck
endif
let mapleader = ","
nmap <leader>v :vs $MYVIMRC<CR>
" }}}

