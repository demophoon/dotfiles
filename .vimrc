" ============================================================================
"
" Britt Gresham's 'Perfect' Vimrc
"
" Feel free to take whatever helps you the most
"
" ============================================================================


" ============================================================================
"  Initialization {{{1
" ============================================================================

    " Use Vim settings instead of Vi settings.
    set nocompatible

    " Clear Autocommands
    autocmd!

    " Let Vim look for settings in a file
    set modeline
    set modelines=5

    " If vimrc has been modified, re-source it for fast modifications
    autocmd! BufWritePost *vimrc source %

    " Setting up Vundle - the vim plugin bundler
        let iCanHazVundle=1
        let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
        if !filereadable(vundle_readme)
            echo "Installing Vundle.."
            echo ""
            silent !mkdir -p ~/.vim/bundle
            silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
            let iCanHazVundle=0
        endif
        set rtp+=~/.vim/bundle/vundle/
        call vundle#rc()

        if iCanHazVundle == 0
            echo "Installing Bundles, please ignore key map error messages"
            echo ""
            :BundleInstall
        endif

    " Set Leader
    let mapleader = ","

    " Wildmode options {{{2
    " ----------------
        set wildmenu
        set wildmode=longest:full,full
        set wildignore+=*.o,*.out,*.obj,*.rbc,*.rbo,*.class,*.gem
        set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
        set wildignore+=*.jpg,*.png,*.gif,*.jpeg,*.bmp
        set wildignore+=*.hg,*.git,*.svn
        set wildignore+=*.exe,*.dll
        set wildignore+=*.pyc
        set wildignore+=*.DS_Store
    " }}}

"========================================================================= }}}
" Vundle Bundles {{{1
"============================================================================

    " Required Plugins
    Bundle 'gmarik/vundle'

    " Approved Bundles
    Bundle 'godlygeek/tabular'
    Bundle 'klen/python-mode'
    Bundle 'nelstrom/vim-visual-star-search'
    Bundle 'scrooloose/nerdtree'
    Bundle 'tpope/vim-repeat'
    Bundle 'tpope/vim-speeddating'
    Bundle 'tpope/vim-surround'
    Bundle 'Townk/vim-autoclose'
    Bundle 'pangloss/vim-javascript'
    Bundle 'bling/vim-airline'
    Bundle 'bling/vim-bufferline'
    Bundle 'puppetlabs/puppet-syntax-vim'
    Bundle 'scrooloose/syntastic'
    Bundle 'tristen/vim-sparkup'
    Bundle 'nanotech/jellybeans.vim'
    Bundle 'elzr/vim-json'
    Bundle 'tomtom/tlib_vim'
    Bundle 'SirVer/ultisnips'
    Bundle 'honza/vim-snippets'
    Bundle 'kien/ctrlp.vim'

    " Testing Bundles
    Bundle 'tpope/vim-fugitive'
    Bundle 'tpope/vim-git'
    Bundle 'Lokaltog/vim-easymotion'
    Bundle 'ekalinin/Dockerfile.vim'
    Bundle 'kien/rainbow_parentheses.vim'
    Bundle 'nathanaelkane/vim-indent-guides'
    Bundle 'tpope/vim-dispatch'
    Bundle 'kchmck/vim-coffee-script'
    Bundle 'vim-ruby/vim-ruby'
    "Bundle 'demophoon/bash-fold-expr'
    "autocmd! BufRead,BufEnter *.clj Bundle 'kovisoft/slimv'

    " Overtone stuff!
    Bundle 'guns/vim-clojure-static'
    Bundle 'tpope/vim-fireplace'
    Bundle 'tpope/vim-classpath'

    filetype plugin indent on

" ========================================================================= }}}
"  Filetype Association {{{1
" ============================================================================

    au BufRead,BufNewFile *vimrc set foldmethod=marker

    augroup Puppet
        autocmd! BufEnter *.pp set filetype=puppet tabstop=2 sts=2 shiftwidth=2
    augroup end

    augroup RubySyntaxFiles
        autocmd! BufRead,BufEnter *.rb,*.rake set tabstop=2 sts=2 shiftwidth=2 filetype=ruby
        autocmd! BufEnter Rakefile set filetype=ruby
        autocmd! BufEnter Gemfile set filetype=ruby
    augroup end

    augroup MarkdownFiles " Instead of this Modulo file bullshit
        autocmd! BufEnter *.md set filetype=markdown
    augroup end

    au BufWritePost ~/.bashrc !source %

    au BufRead,BufNewFile *_spec.rb nmap <F8> :!rspec --color %<CR>

    augroup PatchDiffHighlight
        autocmd!
        autocmd BufEnter *.patch,*.rej,*.diff syntax enable
    augroup end

    augroup ClojureFiles
        autocmd! BufRead,BufEnter *.clj let b:AutoClosePairs = AutoClose#ParsePairs("{} [] \"\" `")
    augroup end

" ========================================================================= }}}
"  Look and Feel {{{1
" ============================================================================
    " Basics / Misc {{{2
    " -------------

        " Let netrw show things in a tree structure instead of a flat list
        "let g:netrw_liststyle=3

        " Used for saving git and hg commits
        filetype on
        filetype off

        " Set to allow you to backspace while back past insert mode
        set backspace=2

        " Disable mouse
        set mouse=

        " Increase History
        set history=100

        " Enable relative number in the left column
        set number
        "set relativenumber

        " Give context to where the cursor is positioned in a file
        set scrolloff=14

        " Use UTF-8 encoding
        set encoding=utf-8 nobomb

        " Hide buffers after they are abandoned
        set hidden

        " Disable files that don't need to be created
        set noswapfile
        set nobackup
        set nowritebackup

        " Enable spell checking
        set spell

        " Auto Complete Menu
        set completeopt=longest,menu

        " Hilight current line
        set cursorline

        " Diff ignore whitespace
        set diffopt+=iwhite

    " }}}
    " Tabbing and Spaces {{{2
    " ------------------

        " Use 4 spaces instead of tabs
        set ts=4
        set sts=4
        set shiftwidth=4
        set expandtab

        " Auto indent
        set autoindent

        " replace trailing whitespace and tabs with unicode characters
        exec "set listchars=tab:>-,trail:$,nbsp:~"
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
        set showmatch
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
        try
            colorscheme jellybeans
        catch
            colorscheme darkblue
        endtry

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
" ========================================================================= }}}
"  Plugin Settings {{{1
" ============================================================================
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
        let g:NERDTreeChDirMode=2
    " }}}
    " Python Mode Settings {{{2
    " --------------------
        let g:pymode_lint_checker = "pyflakes,pep8"
        let g:pymode_lint_onfly = 0
        let g:pymode_folding = 0
        let g:pymode_rope_complete_on_dot = 0
        let g:pymode_rope_lookup_project = 0
        let g:pymode_rope_regenerate_on_write = 0
    " }}}
    " CtrlP Settings {{{2
    " --------------------
        let g:crtlp_show_hidden=1
        let g:ctrlp_working_path_mode='rw'
    " }}}
    " Indent Guides {{{2
    " --------------------
        let g:indent_guides_guide_size=1
    " }}}
    " Slimv {{{2
    " --------------------
        let g:slimv_leader=',,'
    " }}}
"" ======== }}}
"  Mappings {{{1
" ============================================================================
    " Disable Q (Command Shell Mode) {{{2
    " ------------------------------
        nnoremap Q <nop>
        nnoremap gq <nop>
        nnoremap q: <nop>
    " }}}
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
        nnoremap <Space> za
        vnoremap <Space> za
    " }}}
    " Zencoding {{{2
    " ---------
        let g:user_zen_leader_key='<c-e>'
        let g:use_zen_complete_tag = 1
    " }}}
    " Misc {{{2
    " ----
        imap jj <Esc>:redraw!<CR>:syntax sync fromstart<CR>
    " }}}
    " Vimrc Toggle {{{2
    " ------------
        function! ToggleVimrc()
            if expand("%:p") =~ $MYVIMRC
                :bd
            else
                :vsp $MYVIMRC
            endif
        endfunction
        nmap <leader>v :call ToggleVimrc()<CR>
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
        nnoremap <leader>n :call NERDTreeToggleOrFocus()<CR>
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
                if CanExpandSnippet() > 0
                    return "\<C-r>=TriggerSnippet()\<cr>"
                else
                    return "\<c-p>"
                endif
            endif
        endfunction
        "inoremap <tab> <c-r>=InsertTabWrapper()<cr>
        "inoremap <s-tab> <c-n>
        "inoremap <c-c> <C-r>=TriggerSnippet()<cr>
    " }}}
    " Toggle Paste/No Paste {{{2
    " --------------------
        nnoremap <leader>p :set paste!<CR>
    " }}}
    " Don't use Vim Regex {{{2
    " --------------------
        nnoremap / /\v
        vnoremap / /\v
    " }}}
    " Keep search matches in the center of the screen {{{2
    " --------------------
        nnoremap n nzzzv
        nnoremap N Nzzzv
    " }}}
    " Sudo write {{{2
    " --------------------
        cnoremap w!! w !sudo tee % >/dev/null
    " }}}
    " Insert Last Command {{{2
    " --------------------
        cnoremap :: <C-r>:
    " }}}
    " '' to `` and `` to '' {{{2
    " --------------------
        nnoremap '' ``
        nnoremap `` ''
    " }}}
    " Leader Maps {{{2
    " --------------------
        " Clear matches
        noremap <silent> <leader><space> :noh<cr>:call clearmatches()<cr>
        " Clean trailing whitespace
        nnoremap <leader>ww mz:%s/\s\+$//<cr>:let @/=''<cr>`z"
        " Redraw screen. Sometimes shit happens.
        nnoremap <leader>r :syntax sync fromstart<cr>:redraw!<cr>
        " Focus current fold
        nnoremap <leader>f mzzMzvzz15<c-e>`z<cr>
        " Rspec Tests
        function! RSpecCurrent()
          execute("!clear && rspec " . expand("%p") . ":" . line("."))
        endfunction
        " Toggle Scrollbind
        function! ScrollbindToggle()
            if &scrollbind
                set noscrollbind
            else
                set scrollbind
            endif
        endfunction
        nnoremap <leader>s :call ScrollbindToggle()<cr>
        " Toggle Diff Mode
        function! DiffToggle()
            if &diff
                diffoff
            else
                diffthis
                set fdm=diff
            endif
        endfunction
        nnoremap <leader>d :call DiffToggle()<cr>
    " }}}
    " c-* mappings {{{2
    " --------------------
        nnoremap <c-e> :Eval<CR>
        vnoremap <c-e> :Eval<CR>
    " }}}
" ========================================================================= }}}
"  Performance Optimizations {{{1
" ============================================================================

    " Fast terminal connections
    set ttyfast

    " Don't redraw when running macros
    set lazyredraw

    " Dear Future Britt,
    "   Don't you dare turn on these settings. I've left this here for you as
    "   a note to save yourself the trouble of accidentally turning it on or
    "   adding it in the future. IT FUCKS UP YOUR BEAUTIFUL TEXT OBJECTS AND
    "   WILL INFURIATE YOU TO NO END.
    "
    "   Sincerely,
    "       A very irritated version of yourself.
    "       - 10/2/2014
    " Set timeout on keycodes but not mappings
    "set notimeout
    "set ttimeout
    "set ttimeoutlen=10

    " Syntax optimazations
    syntax sync minlines=256
    " set syntaxcol=256

" ======================================================================== }}}
"  Mini Plugins {{{1
" ============================================================================
" Thanks https://bitbucket.org/sjl/dotfiles
    " Highlight Word {{{2
    "
    " This mini-plugin provides a few mappings for highlighting words temporarily.
    "
    " Sometimes you're looking at a hairy piece of code and would like a certain
    " word or two to stand out temporarily.  You can search for it, but that only
    " gives you one color of highlighting.  Now you can use <leader>N where N is
    " a number from 1-6 to highlight the current word in a specific color.
        function! HiInterestingWord(n) " {{{3
            " Save our location.
            normal! mz

            " Yank the current word into the z register.
            normal! "zyiw

            " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
            let mid = 86750 + a:n

            " Clear existing matches, but don't worry if they don't exist.
            silent! call matchdelete(mid)

            " Construct a literal pattern that has to match at boundaries.
            let pat = '\V\<' . escape(@z, '\') . '\>'

            " Actually match the words.
            call matchadd("InterestingWord" . a:n, pat, 1, mid)

            " Move back to our original location.
            normal! `z
        endfunction " }}}
        function! ViHiInterestingWord(n) " {{{3
            " Yank the current word into the z register.
            normal! gv"zy

            " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
            let mid = 86750 + a:n

            " Clear existing matches, but don't worry if they don't exist.
            silent! call matchdelete(mid)

            " Construct a literal pattern that has to match at boundaries.
            let pat = escape(@z, '\')

            " Actually match the words.
            call matchadd("InterestingWord" . a:n, pat, 1, mid)

        endfunction " }}}
        " Mappings {{{3

        nnoremap <silent> <leader>h1 :call HiInterestingWord(1)<cr>
        nnoremap <silent> <leader>h2 :call HiInterestingWord(2)<cr>
        nnoremap <silent> <leader>h3 :call HiInterestingWord(3)<cr>
        nnoremap <silent> <leader>h4 :call HiInterestingWord(4)<cr>
        nnoremap <silent> <leader>h5 :call HiInterestingWord(5)<cr>
        nnoremap <silent> <leader>h6 :call HiInterestingWord(6)<cr>
        nnoremap <silent> <leader>h7 :call HiInterestingWord(7)<cr>
        nnoremap <silent> <leader>h8 :call HiInterestingWord(8)<cr>
        nnoremap <silent> <leader>h9 :call HiInterestingWord(9)<cr>
        nnoremap <silent> <leader>h0 :call HiInterestingWord(0)<cr>

        vnoremap <silent> <leader>h1 :call ViHiInterestingWord(1)<cr>
        vnoremap <silent> <leader>h2 :call ViHiInterestingWord(2)<cr>
        vnoremap <silent> <leader>h3 :call ViHiInterestingWord(3)<cr>
        vnoremap <silent> <leader>h4 :call ViHiInterestingWord(4)<cr>
        vnoremap <silent> <leader>h5 :call ViHiInterestingWord(5)<cr>
        vnoremap <silent> <leader>h6 :call ViHiInterestingWord(6)<cr>
        vnoremap <silent> <leader>h7 :call ViHiInterestingWord(7)<cr>
        vnoremap <silent> <leader>h8 :call ViHiInterestingWord(8)<cr>
        vnoremap <silent> <leader>h9 :call ViHiInterestingWord(9)<cr>
        vnoremap <silent> <leader>h0 :call ViHiInterestingWord(0)<cr>

        " }}}
        " Default Highlights {{{3

        hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#00afff ctermbg=39
        hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#ff5faf ctermbg=205
        hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#5fff00 ctermbg=82
        hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#ffff00 ctermbg=226
        hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff8700 ctermbg=208
        hi def InterestingWord6 guifg=#0000ff ctermfg=12 gui=bold cterm=bold
        hi def InterestingWord7 guifg=#ff00ff ctermfg=13 gui=bold cterm=bold
        hi def InterestingWord8 guifg=#00ff00 ctermfg=10 gui=bold cterm=bold
        hi def InterestingWord9 guifg=#ff5f00 ctermfg=202 gui=bold cterm=bold
        hi def InterestingWord0 guifg=#00ffff ctermfg=14 gui=bold cterm=bold

        " }}}
    " }}}
" ======================================================================== }}}
"  Post Configurations {{{1
" ============================================================================
    " Find local Vim files"
    silent! source ~/.vimrc.local
    silent! source ./.vimrc.local
    " Remap mappings that get overwritten by plugins
    set rtp+=~/.vim/after/
"" }}}
" ============================================================================

" vim: foldmethod=marker foldmarker={{{,}}} ts=4 sts=4 sw=4 expandtab:
