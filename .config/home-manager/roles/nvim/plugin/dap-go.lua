require("dap-go").setup({})
vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>")
vim.keymap.set("n", "<leader>dd", function()
  local widgets = require("dap.ui.widgets");
  local sidebar = widgets.sidebar(widgets.scopes);
  sidebar.open();
  require("dap-go").continue();
end
)
