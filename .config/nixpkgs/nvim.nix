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
  gocode = "${pkgs.gocode.outPath}/bin/gocode";
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

        # HCL
        vim-hcl

        # LSP
        deoplete-nvim
        deoplete-go

        # Treesitter
        nvim-treesitter
        nvim-treesitter-context
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

      nnoremap <c-p> :FZF<CR>

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

      au FileType go set noexpandtab
      au FileType go set shiftwidth=4
      au FileType go set softtabstop=4
      au FileType go set tabstop=4
      au FileType go nmap <F12> <Plug>(go-def)

      let g:go_auto_sameids = 1
      let g:go_fmt_command = "goimports"

      " Error and warning signs.
      let g:ale_sign_error = '⤫'
      let g:ale_sign_warning = '⚠'
      let g:airline#extensions#ale#enabled = 1

      let g:deoplete#enable_at_startup = 1
      let g:deoplete#sources#go#gocode_binary = '${gocode}'

      lua <<EOF
      require('nvim-treesitter.configs').setup {
        ensure_installed = { "go" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
        },
      }

      require('treesitter-context').setup{
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
            default = {
                'class',
                'function',
                'method',
                'for', -- These won't appear in the context
                'while',
                'if',
                'switch',
                'case',
            },
        },
        mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
      }

      EOF
    '';
  };
}
