{ config, pkgs, ... }:

let
  customPlugins = {
    neo-tree-nvim = pkgs.vimUtils.buildVimPlugin {
      name = "neo-tree.nvim";
      version = "3.6";
      src = pkgs.fetchFromGitHub {
        owner = "nvim-neo-tree";
        repo = "neo-tree.nvim";
        rev = "2d89ca96e08eb6e9c8e50e1bb4738bc5125c9f12";
        sha256 = "sha256-l/BA+H8vKSUlixsfJLPkjaVryVRn/e0rmJv07V4V9nY=";
      };
    };
    nvim-web-devicons = pkgs.vimUtils.buildVimPlugin {
      name = "nvim-web-devicons";
      version = "2023.09.20";
      src = pkgs.fetchFromGitHub {
        owner = "nvim-tree";
        repo = "nvim-web-devicons";
        rev = "973ab742f143a796a779af4d786ec409116a0d87";
        sha256 = "sha256-9IPEts+RaM7Xh1ZOS8V/rECyreHK6FRKca52n031u7o=";
      };
    };
    nvim-indent-blankline-nvim = pkgs.vimUtils.buildVimPlugin {
      name = "indent-blankline-nvim";
      version = "2023.11.06";
      src = pkgs.fetchFromGitHub {
        owner = "lukas-reineke";
        repo = "indent-blankline.nvim";
        rev = "9637670896b68805430e2f72cf5d16be5b97a22a";
        sha256 = "sha256-1EpjFIJ5GK9NXS6dTMJ71w/AtLtR6Q5HrAXCIRNOBAY=";
      };
    };
    codecompanion-nvim = pkgs.vimUtils.buildVimPlugin {
      name = "codecompanion.nvim";
      version = "2025.02.10";
      src = pkgs.fetchFromGitHub {
        owner = "olimorris";
        repo = "codecompanion.nvim";
        rev = "68464826515b764ebae5fdf28e4d3f8c01c80296";
        sha256 = "sha256-dXQpOxXJLNtUku8MKAoUaAQ3flrRsvQ7NorVtWN8vH4=";
      };
    };
  };

  python-debugpy = pkgs.python311.withPackages (ps: with ps; [debugpy]);
  debugpy_path = python-debugpy + "/lib/python3.11/site-packages/debugpy";

  vimspector_configuration = {
    adapters = {
      debugpy = {
        command = [
          "${python-debugpy}/bin/python3"
          "${debugpy_path}/adapter"
        ];
        configuration = {
          python = "${python-debugpy}/bin/python3";
        };
        custom_handler = "vimspector.custom.python.Debugpy";
        name = "debugpy";
      };
    };
  };

  toLua = str: "lua << EOF\n${str}\nEOF\n";
  toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";

in {
  home.file.".config/vimspector/gadgets/linux/.gadgets.json".source = pkgs.writeText ".gadgets.json" (builtins.toJSON vimspector_configuration);

  programs.neovim = {
    enable = true;

    extraPackages = with pkgs; [
      # telescope / obsidian-nvim
      ripgrep

      # python dev
      pyright

      # LSPs
      nodePackages_latest.bash-language-server
      terraform-lsp
      nodePackages_latest.typescript-language-server
      vscode-langservers-extracted
      vscode-js-debug

      gopls
    ];

    plugins = with pkgs.vimPlugins; [
        # Required
        tlib_vim
        plenary-nvim

        # Look and feel
        vim-afterglow
        {
          plugin = customPlugins.nvim-web-devicons;
          config = toLuaFile ./plugin/devicons.lua;
        }
        {
          plugin = lualine-nvim;
          config = toLuaFile ./plugin/lualine.lua;
        }
        vim-surround
        vim-repeat
        lexima-vim
        {
          plugin = gitsigns-nvim;
          config = toLuaFile ./plugin/gitsigns.lua;
        }
        nui-nvim
        {
          plugin = customPlugins.nvim-indent-blankline-nvim;
          config = toLuaFile ./plugin/indent-blankline.lua;
        }

        # Autodetect shiftwidth
        vim-sleuth

        # Code Completion / Snippets
        emmet-vim

        # File traversal
        {
          plugin = customPlugins.neo-tree-nvim;
          config = toLuaFile ./plugin/neotree.lua;
        }
        customPlugins.neo-tree-nvim
        nerdtree
        telescope-nvim

        # Git
        vim-fugitive

        # Shell
        vim-shellcheck

        # DAP
        nvim-nio
        {
          plugin = nvim-dap;
          config = toLuaFile ./plugin/dap.lua;
        }
        nvim-dap-ui
        {
          plugin = nvim-dap-go;
          config = toLuaFile ./plugin/dap-go.lua;
        }
        {
          plugin = nvim-dap-python;
          config = toLuaFile ./plugin/dap-python.lua;
        }

        # JS
        nvim-lsp-ts-utils

        # HCL
        vim-hcl

        # LSP
        {
          plugin = nvim-lspconfig;
          config = toLuaFile ./plugin/lspconfig.lua;
        }
        nvim-lspconfig
        {
          plugin = nvim-cmp;
          config = toLuaFile ./plugin/cmp.lua;
        }
        cmp-buffer
        cmp-nvim-lsp
        nvim-snippy
        cmp-snippy
        vim-snippets

        lsp_signature-nvim

        # Treesitter
        {
          plugin = nvim-treesitter;
          config = toLuaFile ./plugin/treesitter.lua;
        }
        {
          plugin = nvim-treesitter-context;
          config = toLuaFile ./plugin/treesitter-context.lua;
        }
        {
          plugin = nvim-treesitter-textobjects;
          config = toLuaFile ./plugin/treesitter-textobjects.lua;
        }

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
        nvim-treesitter-parsers.typescript
        nvim-treesitter-parsers.vue
        nvim-treesitter-parsers.yaml
        nvim-treesitter-parsers.lua
        nvim-treesitter-parsers.vimdoc

        # Note Taking
        vimwiki

        # AI
        {
          plugin = customPlugins.codecompanion-nvim;
          config = toLuaFile ./plugin/codecompanion.lua;
        }

    ];

    extraConfig = ''
      ${builtins.readFile ./config/.vimrc}
    '';

    extraLuaConfig = ''
      ${builtins.readFile ./config/options.lua}
    '';
  };
}
