call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

set hidden
set number
set ts=4 sts=4 sw=4 expandtab
set smartindent
syntax on
colorscheme codeschool


if has("autocmd")
    autocmd bufwritepost .vimrc source $MYVIMRC
endif

let mapleader = ","
nmap <leader>v :tabedit $MYVIMRC<CR>

