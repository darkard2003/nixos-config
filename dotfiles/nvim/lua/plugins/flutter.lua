return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = true,
  ft = 'dart',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim', -- optional for vim.ui.select
    'mfussenegger/nvim-dap',
  },
  config = function()
    local lsp = require "config.lsp"

    require("flutter-tools").setup {
      fvm = true,
      debugger = {
        enabled = true,
      },
      widget_guides = {
        enabled = true,
      },
      lsp = {
        capabilities = lsp.capabilities,
        on_attach = lsp.on_attach,
      },
      dev_log = {
        enabled = false,
      },
    }
    vim.keymap.set('n', '<leader>fn', require('telescope').extensions.flutter.commands, { desc = "Load flutter tools" })
  end
}
