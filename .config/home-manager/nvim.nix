{ config, pkgs, ... }:

let
  customPlugins = {
    jellybeans = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "jellybeans-vim";
      version = "2023-09-11";
      src = pkgs.fetchFromGitHub {
        owner = "nanotech";
        repo = "jellybeans.vim";
        rev = "ef83bf4dc8b3eacffc97bf5c96ab2581b415c9fa";
        sha256 = "X+37Mlyt6+ZwfYlt4ZtdHPXDgcKtiXlUoUPZVb58w/8=";
      };
    };
  };
in {
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  programs.neovim = {
    enable = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
        # Required
        tlib_vim
        plenary-nvim

        # Look and feel
        customPlugins.jellybeans
        lualine-nvim
        vim-surround
        vim-repeat
        lexima-vim
        gitsigns-nvim

        # Autodetect shiftwidth
        vim-sleuth

        # Code Completion / Snippets
        vim-snippets
        emmet-vim

        # File traversal
        nerdtree
        telescope-nvim

        # Git
        vim-fugitive

        # Go
        vim-go

        # HCL
        vim-hcl

        # LSP
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        cmp-nvim-lsp-signature-help

        # Treesitter
        nvim-treesitter
        nvim-treesitter-context

        nvim-treesitter-parsers.css
        nvim-treesitter-parsers.dockerfile
        nvim-treesitter-parsers.go
        nvim-treesitter-parsers.hcl
        nvim-treesitter-parsers.html
        nvim-treesitter-parsers.javascript
        nvim-treesitter-parsers.make
        nvim-treesitter-parsers.markdown
        nvim-treesitter-parsers.markdown_inline
        nvim-treesitter-parsers.nix
        nvim-treesitter-parsers.norg
        nvim-treesitter-parsers.python
        nvim-treesitter-parsers.terraform
        nvim-treesitter-parsers.vue
        nvim-treesitter-parsers.yaml

        # Note Taking
        neorg
    ];
    extraConfig = ''
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

      nmap Y y$

      nmap <Tab> za

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
      au FileType go nmap <F12> <Plug>(go-def)

      let g:go_auto_sameids = 1
      let g:go_fmt_command = "goimports"
      let g:go_fmt_options = {}

      " Error and warning signs.
      let g:ale_sign_error = '⤫'
      let g:ale_sign_warning = '⚠'
      let g:airline#extensions#ale#enabled = 1

      let g:user_emmet_leader_key='<C-e>'

      lua <<EOF
      local pid = vim.fn.stdpath("cache") .. "/treesitters"
      vim.fn.mkdir(pid, "p")

      require('nvim-treesitter.configs').setup {
        parser_install_dir = pid,
        ensure_installed = { },
        sync_install = false,
        auto_install = false,
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

      require('lualine').setup {
        options = {
          icons_enabled = false,
          theme = "wombat",
          section_separators = "",
          component_separators = "",
        },
      }

      require('gitsigns').setup()

      require('neorg').setup {
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.summary"] = {},
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes = "~/Notes",
              },
              default_workspace = "notes"
            },
          },
        },
      }

      local cmp = require("cmp")

      cmp.setup{
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
        })
      }

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      require("lspconfig").gopls.setup{
        capabilities = capabilities
      }

    EOF
    '';
  };
}
