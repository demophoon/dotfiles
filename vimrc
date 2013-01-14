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
syntax on
set hidden
colorscheme codeschool

set noerrorbells
set novisualbell
set t_vb=
set tm=500

set nobackup
set nowb
set noswapfile

set laststatus=2
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

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

if has("autocmd")
    autocmd bufwritepost .vimrc source $MYVIMRC
endif

let mapleader = ","
nmap <leader>v :tabedit $MYVIMRC<CR>

function! HasPaste()
    if &paste
        return "PASTE MODE   "
    en
    return ""
endfunction


