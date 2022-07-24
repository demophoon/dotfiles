{ config, pkgs, ... }:

let
  customPlugins = {
    jellybeans = pkgs.vimUtils.buildVimPlugin {
      name = "jellybeans.vim";
      src = pkgs.fetchFromGitHub {
        owner = "nanotech";
        repo = "jellybeans.vim";
        rev = "ef83bf4dc8b3eacffc97bf5c96ab2581b415c9fa";
        sha256 = "X+37Mlyt6+ZwfYlt4ZtdHPXDgcKtiXlUoUPZVb58w/8=";
      };
    };
  };
in {
  programs.neovim = {
    enable = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
        # Required
        tlib_vim

        # Look and feel
        customPlugins.jellybeans
        vim-airline
        vim-surround
        vim-repeat
        lexima-vim

        # Code Completion / Snippets
        sparkup
        vim-snippets

        # File traversal
        nerdtree
        fzf-vim

        # Git
        vim-fugitive

        # Go
        vim-go

        # LSP
        deoplete-nvim
        deoplete-go
    ];
    extraConfig = ''
      set nocompatible
      autocmd!

      let mapleader = ","

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

      exec "set listchars=tab:>-,trail:$,nbsp:~"
      set list

      set hlsearch
      set incsearch
      set ignorecase
      set smartcase
      set showmatch
      set gdefault
      syntax enable
      set t_Co=256
      colorscheme jellybeans

      highlight ExtraWhitespace ctermbg=darkblue guibg=darkblue
      match ExtraWhitespace /\s\+$/

      set undofile
      set undodir=$HOME/.vim/tmp,$HOME/.tmp,$HOME/tmp,$HOME/var/tmp,/tmp


      autocmd BufReadPost *  if line("'\"") > 1 && line("'\"") <= line("$")
                 \|     exe "normal! g`\""
                 \|  endif

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

      nnoremap Y y$

      nnoremap <Tab> za

      map <C-h> <C-w>h
      map <C-j> <C-w>j
      map <C-k> <C-w>k
      map <C-l> <C-w>l

      function! NERDTreeToggleOrFocus()
          if expand("%") =~ "NERD_tree"
              :NERDTreeToggle
          else
              call NERDTreeFocus()
          endif
      endfunction
      nnoremap <leader>n :call NERDTreeToggleOrFocus()<CR>

      nnoremap <leader>p :set paste!<CR>

      nnoremap / /\v
      vnoremap / /\v

      nnoremap n nzzzv
      nnoremap N Nzzzv

      function! DiffToggle()
          if &diff
              diffoff
          else
              diffthis
              set fdm=diff
          endif
      endfunction
      nnoremap <leader>d :call DiffToggle()<cr>

      nnoremap <c-p> :FZF<CR>

      set ttyfast
      set lazyredraw
    '';
  };
}
