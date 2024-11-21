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

