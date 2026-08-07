return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      {
        "williamboman/mason.nvim",
        dependencies = {
          "williamboman/mason-lspconfig.nvim",
        },
      },
      {
        'hrsh7th/nvim-cmp',
        dependencies = {
          'onsails/lspkind.nvim',
          'neovim/nvim-lspconfig',
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-buffer',
          'hrsh7th/cmp-path',
          'hrsh7th/cmp-cmdline',
          {
            'L3MON4D3/LuaSnip',
            dependencies = {
              "saadparwaiz1/cmp_luasnip",
              "rafamadriz/friendly-snippets"
            },
          },
        },
      },
    }
  },
  config = function()
    require "config.nvim-cmp"
    require('mason').setup()
    local lsp = require "config.lsp"
    lsp.setup()
    local mason_lsp = require 'mason-lspconfig'
    mason_lsp.setup({
      ensure_installed = { "lua_ls" },
      automatic_enable = false,
    })
    local handler = lsp.handler
    local servers = mason_lsp.get_installed_servers()
    for _, server in ipairs(servers) do
      handler(server)
    end

  end
}
