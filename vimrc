" vim: foldmethod=marker
" Britt Gresham's Vimrc

" Initialization {{{1
    autocmd! BufWritePost .vimrc source %
    if has("unix")
        set rtp+=~/.vim/bundle/vundle/
        call vundle#rc()
    elseif has("win32")
        set rtp+=~/vimfiles/bundle/vundle/
        call vundle#rc("~/vimfiles/bundle")
    endif
" }}}
" Filetype Association {{{1
    au BufRead,BufNewFile .vimrc
      \ set foldmethod=marker
    au BufRead,BufNewFile *.pp
      \ set filetype=puppet
    au BufRead,BufNewFile *_spec.rb
      \ nmap <F8> :!rspec --color %<CR>
" }}}
" Look and Feel {{{1
    " Basics / Misc {{{2
        set nocompatible
        filetype on
        filetype off
        set backspace=2
        set mouse=
        set history=100
        set number
        set scrolloff=5
        set encoding=utf-8
        set hidden
        set noswapfile
        set nobackup
        set nowb
        set lazyredraw
        set spell
    " }}}
    " Tabbing and Spaces {{{2
        set ts=4 sts=4 sw=4 expandtab
        set autoindent
    " }}}
    " Color Settings {{{2
        let &colorcolumn="80,".join(range(120,999), ',')
        highlight colorcolumn ctermbg=8 guibg=#000000
        set hls
        syntax enable
        set guifont=Inconsolata\ for\ Powerline:h14
        if has("gui_running")
            if has("gui_win32")
                set guifont=Consolas:h10:cANSI
            endif
        else
            set t_Co=256
        endif
        colorscheme smyck
    " }}}
    " Highlight Trailing Whitespace {{{2
        highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
        match ExtraWhitespace /\s\+$/
    " }}}
    " Persistent Undo {{{2
        if v:version >= 703
            set undofile
            set undodir=~/.vim/tmp,~/.tmp,~/tmp,~/var/tmp,/tmp
        endif
    " }}}
    " Spelling / Typos {{{2
        :command! WQ wq
        :command! Wq wq
        :command! W w
        :command! Q q
    " }}}
" }}}
" Vundle Bundles {{{1
"
    " Required Plugins
    Bundle 'gmarik/vundle'

    " Approved Bundles
    Bundle 'godlygeek/tabular'
    Bundle 'klen/python-mode'
    Bundle 'msanders/snipmate.vim'
    Bundle 'nelstrom/vim-visual-star-search'
    Bundle 'scrooloose/nerdtree'
    Bundle 'tpope/vim-repeat'
    Bundle 'tpope/vim-speeddating'
    Bundle 'tpope/vim-surround'
    Bundle 'vim-scripts/AutoClose'
    Bundle 'pangloss/vim-javascript'
    Bundle 'bling/vim-airline'
    Bundle 'bling/vim-bufferline'
    Bundle 'puppetlabs/puppet-syntax-vim'
    Bundle 'scrooloose/syntastic'

    " Testing Bundles
    Bundle 'tristen/vim-sparkup'
    Bundle 'tpope/vim-fugitive'
    Bundle 'tpope/vim-git'
    Bundle 'hsitz/VimOrganizer'

    filetype plugin indent on
" }}}
" Plugin Settings {{{1
    " Airline Settings {{{2
        let g:airline#extensions#tabline#enabled = 1
        set laststatus=2
    " }}}
    " Vim Session Persist {{{2
        let g:session_autosave = 1
        let g:session_autoload = 1
    " }}}
    " Snippets Variables {{{2
        let g:snips_author = 'Britt Gresham'
    " }}}
    " NERDTree {{{2
        let NERDTreeIgnore=['\.pyc$']
    " }}}
    " Python Mode Settings {{{2
        let g:pymode_lint_checker = "pyflakes,pep8"
        let g:pymode_lint_onfly = 0
        let g:pymode_folding = 0
    " }}}
" }}}
" Mappings {{{1
    " * No longer moves the cursor when hitting it the first time {{{2
        nmap * *Nzz
        nmap # #Nzz
    " }}}
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
    " Y y$ Fix {{{2
        " Why the hell isn't this the normal behavior?
        nnoremap Y y$
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
        imap jj <Esc>:syntax sync fromstart<CR>
    " }}}
    " Vimrc Reload {{{2
        let mapleader = ","
        nmap <leader>v :vsp $MYVIMRC<CR>
    " }}}
    " NERDTreeToggle {{{2
    function! NERDTreeToggleOrFocus()
        if expand("%") =~ "NERD_tree"
            :NERDTreeToggle
        else
            call NERDTreeFocus()
        endif
    endfunction
        nmap <leader>n :call NERDTreeToggleOrFocus()<CR>
    " }}}
    " Quickfix list nav with C-n and C-m {{{2
        map <C-n> :cn<CR>
        map <C-m> :cp<CR>
    " }}}
" }}}
