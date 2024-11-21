require("neo-tree").setup({
  source_selector = {
    winbar = true,
    statusline = false
  },
  default_component_configs = {
    git_status = {
      symbols = {
        added      = "+",
        modified   = "~",
        deleted    = "-",
        renamed    = "%",
        untracked  = "?",
        ignored    = "^",
        unstaged   = ".",
        staged     = "*",
        conflict   = "!",
      },
    },
  },
  window = {
    width = 30,
    mappings = {
      ["o"] = {"open", nowait = true},
      ["I"] = "toggle_hidden",
      ["/"] = "noop",
      ["m"] = {
        "show_help",
        nowait=false,
        config = {
          title = "File Menu",
          prefix_key = "m",
        },
      },
      ["ma"] = {
        "add",
        config = { show_path = "relative" },
      },
      ["mm"] = "rename",
      ["mc"] = "copy",
      ["md"] = "delete",
    },
  }
})

