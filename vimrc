" vim: foldmethod=marker foldmarker={{{,}}} ts=2 sts=2 sw=2 expandtab:
" Britt Gresham's 'Perfect' Vimrc
"
" Feel free to take whatever helps you the most
"

"" ==============
"  Initialization {{{1
"" ==============

    " Clear Autocommands
    autocmd!

    " If vimrc has been modified, re-source it for fast modifications
    autocmd! BufWritePost *vimrc source %

    " Source Vundle
    if has("unix")
        set rtp+=~/.vim/bundle/vundle/
        call vundle#rc()
    elseif has("win32")
        set rtp+=~/vimfiles/bundle/vundle/
        call vundle#rc("~/vimfiles/bundle")
    endif

    " Wildmode options {{{2
    " ----------------
        set wildmenu
        set wildmode=longest:full,full
        set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
        set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
        set wildignore+=*.pyc
    " }}}

"" ==================== }}}
"  Filetype Association {{{1
"" ====================

    au BufRead,BufNewFile *vimrc
      \ set foldmethod=marker
    au BufRead,BufNewFile *.pp
      \ set filetype=puppet
    au BufRead,BufNewFile *_spec.rb
      \ nmap <F8> :!rspec --color %<CR>
    augroup PatchDiffHighlight
        autocmd!
        autocmd BufEnter *.patch,*.rej,*.diff syntax enable
    augroup END

"" ============= }}}
"  Look and Feel {{{1
"" =============
    " Basics / Misc {{{2
    " -------------

        " Use Vim settings instead of Vi settings.
        set nocompatible

        " Let netrw show things in a tree structure instead of a flat list
        let g:netrw_liststyle=3

        " Used for saving git and hg commits
        filetype on
        filetype off

        " Set to allow you to backspace while back past insert mode
        set backspace=2

        " Disable mouse
        set mouse=

        " Increase History
        set history=100

        " Enable numbers in the left column
        set number

        " Give context to where the cursor is positioned in a file
        set scrolloff=14

        " Use UTF-8 encoding
        set encoding=utf-8 nobomb

        " Hide buffers after they are abandoned
        set hidden

        " Disable files that don't need to be created
        set noswapfile
        set nobackup
        set nowb

        " Enable spell checking
        set spell
    " }}}
    " Tabbing and Spaces {{{2
    " ------------------

        " Use 4 spaces instead of tabs
        set ts=4 sts=4 sw=4 expandtab

        " Auto indent
        set autoindent

        " replace trailing whitespace and tabs with unicode characters
        exec "set listchars=tab:\uBB\uBB,trail:\u2716,nbsp:~"
        set list

    " }}}
    " Color Settings {{{2
    " --------------

        " Highlight on 80th and after 120th columns
        " highlight ColorColumnText ctermbg=darkgrey guibg=darkgrey
        " all matchadd('ColorColumnText', '\%80v', 1000)
        " all matchadd('ColorColumnText', '\%>120v.\+', 1000)

        " Enable highlight search and highlight when searching
        set hlsearch
        set incsearch
        set ignorecase
        set smartcase
        set gdefault

        " Enable syntax highlighting
        syntax enable

        " Set font and color scheme for Gvim
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
    " -----------------------------
        highlight ExtraWhitespace ctermbg=darkblue guibg=darkblue
        match ExtraWhitespace /\s\+$/
    " }}}
    " Persistent Undo {{{2
    " ---------------
        if v:version >= 703
            set undofile
            set undodir=~/.vim/tmp,~/.tmp,~/tmp,~/var/tmp,/tmp
        endif
    " }}}
    " Spelling / Typos {{{2
    " ----------------
        :command! WQ wq
        :command! Wq wq
        :command! W w
        :command! Q q
    " }}}
    " Open file and goto previous location {{{2
    " ------------------------------------
        autocmd BufReadPost *  if line("'\"") > 1 && line("'\"") <= line("$")
                   \|     exe "normal! g`\""
                   \|  endif
    " }}}
"" ============== }}}
"  Vundle Bundles {{{1
"" ==============

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
    Bundle 'xolox/vim-misc'
    Bundle 'xolox/vim-notes'

    Bundle 'PProvost/vim-ps1'

    filetype plugin indent on

"" =============== }}}
"  Plugin Settings {{{1
"" ===============
    " Airline Settings {{{2
    " ----------------
        let g:airline#extensions#tabline#enabled = 1
        set laststatus=2
    " }}}
    " Vim Session Persist {{{2
    " -------------------
        let g:session_autosave = 1
        let g:session_autoload = 1
    " }}}
    " Snippets Variables {{{2
    " ------------------
        let g:snips_author = 'Britt Gresham'
    " }}}
    " NERDTree {{{2
    " --------
        let NERDTreeIgnore=['\.pyc$']
    " }}}
    " Python Mode Settings {{{2
    " --------------------
        let g:pymode_lint_checker = "pyflakes,pep8"
        let g:pymode_lint_onfly = 0
        let g:pymode_folding = 0
    " }}}
    " Note Taking {{{2
    " -----------
        let g:notes_title_sync='change_title'
        let g:notes_smart_quotes = 0
    " }}}
"" ======== }}}
"  Mappings {{{1
"" ========
    " * No longer moves the cursor when hitting it the first time {{{2
    " -----------------------------------------------------------
        nmap * *Nzz
        nmap # #Nzz
    " }}}
    " Disable Arrows {{{2
    " --------------
        nmap <Left> :vertical resize -5<CR>
        nmap <Up> :resize -5<CR>
        nmap <Right> :vertical resize +5<CR>
        nmap <Down> :resize +5<CR>
        imap <Left> <Esc><Esc>a
        imap <Up> <Esc><Esc>a
        imap <Right> <Esc><Esc>a
        imap <Down> <Esc><Esc>a
    " }}}
    " Y y$ Fix {{{2
    " --------
        " Why the hell isn't this the normal behavior?
        nnoremap Y y$
    " }}}
    " Easy Window Switching {{{2
    " ---------------------
        map <C-h> <C-w>h
        map <C-j> <C-w>j
        map <C-k> <C-w>k
        map <C-l> <C-w>l
    " }}}
    " Space folds and unfolds {{{2
    " -----------------------
        nmap <Space> za
    " }}}
    " Zencoding {{{2
    " ---------
        let g:user_zen_leader_key='<c-e>'
        let g:use_zen_complete_tag = 1
    " }}}
    " Misc {{{2
    " ----
        imap jj <Esc>:syntax sync fromstart<CR>
    " }}}
    " Vimrc Reload {{{2
    " ------------
        let mapleader = ","
        nmap <leader>v :vsp $MYVIMRC<CR>
    " }}}
    " NERDTreeToggle {{{2
    " --------------
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
    " ----------------------------------
        map <C-n> :cn<CR>
        map <C-m> :cp<CR>
    " }}}
    " Format JSON with python {{{2
    " -----------------------
        map <Leader>j !python -m json.tool<CR>
    " }}}
    " Multipurpose Tab-key {{{2
    " --------------------
    " Taken from https://github.com/gregstallings/vimfiles/blob/master/vimrc
        " Indent if at the beginning of a line, else do completion
        function! InsertTabWrapper()
          let col = col('.') - 1
          if !col || getline('.')[col - 1] !~ '\k'
            return "\<tab>"
          else
            return "\<c-p>"
          endif
        endfunction
        inoremap <tab> <c-r>=InsertTabWrapper()<cr>
        inoremap <s-tab> <c-n>
    " }}}
    " Toggle Paste/No Paste {{{2
    " --------------------
        function! TogglePaste()
            if &paste
                :set nopaste
            else
                :set paste
            endif
        endfunction
        nmap <leader>p :call TogglePaste()<CR>
    " }}}
"" ========================= }}}
"  Performance Optimizations {{{1
"" =========================

    " Fast terminal connections
    set ttyfast

    " Don't redraw when running macros
    set lazyredraw

    " Set timeout on keycodes but not mappings
    set notimeout
    set ttimeout
    set ttimeoutlen=100

    " Syntax optimazations
    syntax sync minlines=256
    " set syntaxcol=256

"" =================== }}}
"  Post Configurations {{{1
"" ===================
    " Find ./*.vimrc"
    if filereadable("./custom.vimrc")
        echo "Loading ./custom.vimrc"
        source ./custom.vimrc
    endif
"" }}}
"" ==============
