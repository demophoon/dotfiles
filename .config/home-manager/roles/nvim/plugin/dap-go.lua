require("dap-go").setup({})
vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>")
vim.keymap.set("n", "<leader>dd", function()
  local widgets = require("dap.ui.widgets");
  local sidebar = widgets.sidebar(widgets.scopes);
  sidebar.open();
  require("dap-go").continue();
end
)
vim.keymap.set("n", "c-c", "<cmd>DapContinue<CR>")
vim.keymap.set("n", "c-s", "<cmd>DapStepOver<CR>")
vim.keymap.set("n", "c-n", "<cmd>DapStepInto<CR>")
vim.keymap.set("n", "c-N", "<cmd>DapStepOut<CR>")
