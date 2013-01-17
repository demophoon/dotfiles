call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Basics
set t_Co=256
set nocompatible
set mouse=a
set history=100
set number
set ts=4 sts=4 sw=4 expandtab
set autoindent
set hidden
syntax enable
" set background=dark
" colorscheme solarized
colorscheme codeschool

set noerrorbells
set novisualbell
set t_vb=
set tm=500

set nobackup
set nowb
set noswapfile

" Disable Up, Down, Left, Right. LEARN HJKL NOW!
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>

" Folding Quickly open and close Folds with Spacebar
nnoremap <Space> za

" Exit Insert Mode with jj
imap jj <Esc>

" ZenCoding Mapped to <C-e> instead of <C-y>
" let g:user_zen_expandabbr_key='<c-e>'
let g:user_zen_leader_key='<c-e>'
let g:use_zen_complete_tag = 1

set laststatus=2

if has("autocmd")
    autocmd bufwritepost .vimrc source $MYVIMRC
endif

let mapleader = ","
nmap <leader>v :tabedit $MYVIMRC<CR>

" If Gui is running
if has("gui_running")
    set transparency=10
endif

