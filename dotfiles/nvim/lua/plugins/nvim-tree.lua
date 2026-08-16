return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {
      disable_netrw = true,
      hijack_netrw = true,
      view = {
        side = "right",
        float = {
          enable = true,
        }
      },
      filters = {
        dotfiles = true,
        git_ignored = true,
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },

    }
    local api = require("nvim-tree.api")
    vim.keymap.set("n", "<leader>e", function() api.tree.toggle() end, { desc = "Toggle nvim-tree" })
  end,
}
