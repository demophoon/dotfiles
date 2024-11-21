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
