local dap = require('dap')

dap.configurations.zig = {
  {
    name = "Launch Zig Program",
    type = "codelldb",
    request = "launch",
    terminal = "integrated",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/zig-out/bin/', 'file')
    end,
    args = function()
      local args_string = vim.fn.input("Arguments: ")
      return vim.split(args_string, " +")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
  {
    name = "Select and attach to process",
    type = "codelldb",
    request = "attach",
    pid = function()
      local name = vim.fn.input('Executable name (filter): ')
      return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = '${workspaceFolder}',
  },
}
