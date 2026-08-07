return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local tab_sectiony = {}
    local tab_sectionx = {}
    local has_minuet, minuet = pcall(require, "minuet.lualine")
    if has_minuet then
      table.insert(tab_sectionx, { minuet })
    end
    local has_vc, vc = pcall(require, "vectorcode.integrations")
    if has_vc then
      table.insert(tab_sectiony, vc.lualine({}))
    end
    require 'lualine'.setup({
      options = {
        disabled_filetypes = {
          statusline = { "NvimTree", "toggleterm" }
        },
      },
      tabline = {
        lualine_x = tab_sectionx,
        lualine_y = tab_sectiony,
      }
    })
  end
}
