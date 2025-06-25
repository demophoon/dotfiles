set nocompatible
autocmd!

let mapleader = ","
let maplocalleader = ","

set backspace=2
set mouse=
set history=100
set number
set scrolloff=14
set encoding=utf8 nobomb
set hidden
set noswapfile
set nobackup
set nowritebackup
set spell
set completeopt=longest,menu
set cursorline
set diffopt+=iwhite
set showcmd

set ts=2
set sts=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent

set listchars=tab:\ \ ,trail:$,nbsp:~
set list

set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
set gdefault
syntax enable
set t_Co=256
colorscheme afterglow
hi Normal guibg=NONE ctermbg=NONE

highlight ExtraWhitespace ctermbg=darkblue guibg=darkblue
match ExtraWhitespace /\s\+$/

highlight CopilotSuggestion guifg=#881798 ctermfg=5

set undofile
set undodir=$HOME/.vim/tmp,$HOME/.tmp,$HOME/tmp,$HOME/var/tmp,/tmp


autocmd BufReadPost *  if line("'\"") > 1 && line("'\"") <= line("$")
           \|     exe "normal! g`\""
           \|  endif

autocmd BufNewFile *.norg :Neorg inject-metadata

set splitbelow
set splitright

nmap * *Nzz
nmap # #Nzz

nmap <Left> :vertical resize -5<CR>
nmap <Up> :resize -5<CR>
nmap <Right> :vertical resize +5<CR>
nmap <Down> :resize +5<CR>
imap <Left> <Esc><Esc>a
imap <Up> <Esc><Esc>a
imap <Right> <Esc><Esc>a
imap <Down> <Esc><Esc>a

nmap Y y$

nnoremap <C-I> <C-O>
nmap <Tab> za

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

function! FSToggleOrFocus()
    if expand("%") =~ "neo-tree"
        :Neotree toggle
    else
        :Neotree focus
    endif
endfunction
nnoremap <leader>n :call FSToggleOrFocus()<CR>
nnoremap <leader><leader> :Neorg workspace notes<CR>

nnoremap <leader>p :set paste!<CR>

nnoremap / /\v
vnoremap / /\v

nnoremap n nzzzv
nnoremap N Nzzzv

tnoremap <Esc> <C-\><C-n>

function! DiffToggle()
    if &diff
        diffoff
    else
        diffthis
        set fdm=diff
    endif
endfunction
nnoremap <leader>d :call DiffToggle()<cr>

nnoremap <c-p> :Telescope find_files hidden=true<cr>
nnoremap <leader>tg :Telescope live_grep hidden=true<CR>
nnoremap <leader>tc :Telescope lsp_incoming_calls hidden=true<CR>
nnoremap <leader>tv :Telescope git_commits hidden=true<CR>

nnoremap <leader>gb :GoDebugBreakpoint<cr>

set ttyfast
set lazyredraw

" Plugin settings
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_bin_path = expand("$HOME")."/.go-vim/"

au FileType go set noexpandtab
au FileType go set shiftwidth=4
au FileType go set softtabstop=4
au FileType go set tabstop=4

let g:go_auto_sameids = 1
let g:go_fmt_command = "goimports"
let g:go_fmt_options = {}

" Error and warning signs.
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
let g:airline#extensions#ale#enabled = 1

let g:user_emmet_leader_key='<C-e>'

" let g:vimspector_enable_mappings='HUMAN'
" let g:vimspector_base_dir=expand("$HOME").'/.config/vimspector'

" nmap <S-F3> :call vimspector#Stop()<CR>
" nmap <F2> :call vimspector#Reset()<CR>
