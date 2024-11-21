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
