vim.diagnostic.config({
  virtual_text = {
    prefix = '▎',
  },
  float = {
    prefix = ' ',
  },
  underline = true,
})

vim.keymap.set("n", "<leader><leader>", ":lua vim.diagnostic.open_float( { border=single }, { focus=false })<CR>")

vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]
local border = {
      {"🭽", "FloatBorder"},
      {"▔", "FloatBorder"},
      {"🭾", "FloatBorder"},
      {"▕", "FloatBorder"},
      {"🭿", "FloatBorder"},
      {"▁", "FloatBorder"},
      {"🭼", "FloatBorder"},
      {"▏", "FloatBorder"},
}
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Toggle Zen Mode
vim.keymap.set("n", "<leader>z", function()
  local zenmode = require("zen-mode").toggle()
end)

-- Toggle Twilight
vim.keymap.set("n", "<leader>t", function()
  local zenmode = require("twilight").toggle()
end)
