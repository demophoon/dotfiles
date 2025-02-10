local dap = require("dap")

require("dap-python").setup("python3");
dap.configurations.python = {
  {
    type = 'python';
    request = 'launch';
    name = "Launch file";
    program = "${file}";
    pythonPath = function()
      return '/usr/bin/python3'
    end;
  },
}
