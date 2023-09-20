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
    neo-tree-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "neo-tree.nvim";
      version = "3.6";
      src = pkgs.fetchFromGitHub {
        owner = "nvim-neo-tree";
        repo = "neo-tree.nvim";
        rev = "2d89ca96e08eb6e9c8e50e1bb4738bc5125c9f12";
        sha256 = "sha256-l/BA+H8vKSUlixsfJLPkjaVryVRn/e0rmJv07V4V9nY=";
      };
    };
    nvim-web-devicons = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "nvim-web-devicons";
      version = "2023.09.20";
      src = pkgs.fetchFromGitHub {
        owner = "nvim-tree";
        repo = "nvim-web-devicons";
        rev = "973ab742f143a796a779af4d786ec409116a0d87";
        sha256 = "sha256-9IPEts+RaM7Xh1ZOS8V/rECyreHK6FRKca52n031u7o=";
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
        customPlugins.nvim-web-devicons
        lualine-nvim
        vim-surround
        vim-repeat
        lexima-vim
        gitsigns-nvim
        nui-nvim
        indent-blankline-nvim

        # Autodetect shiftwidth
        vim-sleuth

        # Code Completion / Snippets
        emmet-vim
        vim-vsnip
        cmp-vsnip

        # File traversal
        customPlugins.neo-tree-nvim
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
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
        })
      }

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      require("lspconfig").gopls.setup{
        capabilities = capabilities
      }

      require("neo-tree").setup({
        source_selector = {
          winbar = true,
          statusline = false
        },
        window = {
          mappings = {
            ["o"] = "open",
            ["I"] = "toggle_hidden",
          }
        }
      })

      require('nvim-web-devicons').setup {
        color_icons = true;
      }

      vim.opt.termguicolors = true
      vim.cmd [[highlight IndentBlanklineIndent1 guibg=#1f1f1f gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent2 guibg=#1a1a1a gui=nocombine]]

      require("indent_blankline").setup {
        buftype_exclude = {
          "nofile",
          "terminal",
        },
        filetype_exclude = {
          "help",
          "startify",
          "aerial",
          "alpha",
          "dashboard",
          "lazy",
          "neogitstatus",
          "NvimTree",
          "neo-tree",
          "Trouble",
        },
        context_patterns = {
          "class",
          "return",
          "function",
          "method",
          "^if",
          "^while",
          "jsx_element",
          "^for",
          "^object",
          "^table",
          "block",
          "arguments",
          "if_statement",
          "else_clause",
          "jsx_element",
          "jsx_self_closing_element",
          "try_statement",
          "catch_clause",
          "import_statement",
          "operation_type",
        },
        space_char_blankline = " ",
        show_current_context = true,
        use_treesitter = true,
        char = "",
        context_char = "▏",
        char_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
        },
        space_char_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
        },
        show_trailing_blankline_indent = false,
      }

    EOF
    '';
  };
}
