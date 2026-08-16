return {
  {
    'mfussenegger/nvim-dap',
    config = function()
      require 'config.nvim-dap'
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = "Toggle DAP UI" })

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end
  },
  {
    'leoluz/nvim-dap-go',
    lazy = true,
    ft = 'go',
    opts = {},
  }
}
