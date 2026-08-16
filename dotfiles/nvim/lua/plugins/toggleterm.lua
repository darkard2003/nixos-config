return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require 'toggleterm'.setup {
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<A-i>]],
        direction = "float",
        float_opts = {
          border = "rounded",
        },
        winbar = {
          enabled = true,
        }
      }
      vim.keymap.set('n', '<leader>th', ':ToggleTerm direction=horizontal<CR>',
        { desc = "Toggleterm in horizontal mode" })
      vim.keymap.set('n', '<leader>tf', ':ToggleTerm direction=float<CR>',
        { desc = "Toggleterm in float mode" })
    end
  },
}
