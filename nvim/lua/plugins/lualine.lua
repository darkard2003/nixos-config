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
    local lualine_theme = "auto"
    local wallust_file = vim.fn.expand("~/.cache/wallust/colors-wallust.lua")
    if vim.fn.filereadable(wallust_file) == 1 then
      local ok, wallust = pcall(dofile, wallust_file)
      if ok and wallust then
        lualine_theme = {
          normal = {
            a = { bg = wallust.color4, fg = wallust.background, gui = "bold" },
            b = { bg = wallust.color0, fg = wallust.foreground },
            c = { bg = "NONE", fg = wallust.foreground },
          },
          insert = {
            a = { bg = wallust.color2, fg = wallust.background, gui = "bold" },
            b = { bg = wallust.color0, fg = wallust.foreground },
          },
          visual = {
            a = { bg = wallust.color5, fg = wallust.background, gui = "bold" },
            b = { bg = wallust.color0, fg = wallust.foreground },
          },
          replace = {
            a = { bg = wallust.color1, fg = wallust.background, gui = "bold" },
            b = { bg = wallust.color0, fg = wallust.foreground },
          },
          command = {
            a = { bg = wallust.color3, fg = wallust.background, gui = "bold" },
            b = { bg = wallust.color0, fg = wallust.foreground },
          },
          inactive = {
            a = { bg = wallust.color0, fg = wallust.color8 },
            b = { bg = wallust.color0, fg = wallust.color8 },
            c = { bg = "NONE", fg = wallust.color8 },
          },
        }
      end
    end

    require 'lualine'.setup({
      options = {
        theme = lualine_theme,
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
