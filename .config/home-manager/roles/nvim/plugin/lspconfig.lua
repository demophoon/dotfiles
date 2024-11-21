local cmp = require("cmp")

cmp.setup{
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
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
    { name = 'buffer' },
    { name = 'ultisnips' },
  })
}

local lsp = require("lspconfig")
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

local lsp_on_attach = function(_, bufnr)
  require('lsp_signature').on_attach({
    bind = true,
    always_trigger = true,
  }, bufnr)

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = {
    noremap = true,
    silent  = true,
    buffer  = bufnr,
  }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gk', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
  vim.keymap.set('n', '<F12>', vim.lsp.buf.definition, bufopts)
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("_auto_diag", { clear = true }),
  callback = function(args)
    lsp_on_attach(_, args.buf)
  end,
})

local lsp_settings = {
  gopls = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unreachable = true,
        unusedparams = true,
      },
    },
  },
}

local servers = {
  -- Go
  'gopls',

  -- Python
  'pyright',

  -- HTML/CSS/Javascript
  'tsserver',
  'jsonls',
  'eslint',
  'cssls',
  'html',

  -- Shell
  'bashls',
  --'nixd',

  -- HCL/Terraform
  'terraform_lsp',

  -- Protobuf
  'bufls',

  -- C++
  'ccls',
}

for _, server in pairs(servers) do
  lsp[server].setup{
    on_attach = lsp_on_attach,
    capabilities = lsp_capabilities,
    settings = lsp_settings[server]
  }
end
