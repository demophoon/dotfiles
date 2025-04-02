local dap = require("dap")

function dap_keybind(dap_action, key)
  local dap = require("dap")
  if dap.session() then
    dap_action()
  else
    vim.cmd("normal! " .. key)
  end
end

function dap_entry_keybind(dap_session_action, dap_action)
  local dap = require("dap")
  if dap.session() then
    dap_session_action()
  else
    if vim.fn.filereadable(".vscode/lanuch.json") then
      require("dap.ext.vscode").load_launchjs()
    end
    dap_action()
  end
end

local map = vim.keymap.set
map("n", "<F3>", function () dap_keybind(dap.terminate, "<F3>") end)
map("n", "<F4>", function () dap_keybind(dap.run_last, "<F4>") end)
map("n", "<F5>", function () dap_entry_keybind(dap.repl.open, dap.continue) end)
map("n", "<F6>", function () dap_keybind(dap.pause, "<F6>") end)
map("n", "<F9>", dap.toggle_breakpoint)
map("n", "<F10>", function () dap_keybind(dap.step_over, "<F10>") end)
map("n", "<F11>", function () dap_keybind(dap.step_into, "<F11>") end)
map("n", "<F12>", function () dap_keybind(dap.step_out, "<F12>") end)

-- Adapter config below
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "jsdebug",
    args = {
      "localhost",
      "${port}"
    }
  }
}
for _, language in ipairs({ "typescript", "javascript", "javascriptreact" }) do
  dap.configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Jest Tests",
      trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        "${workspaceFolder}/node_modules/jest/bin/jest.js",
        "--runInBand",
      },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    }
  }
end
