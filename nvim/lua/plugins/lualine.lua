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
    local diff_color = nil

    local function ensure_contrast(fg_hex, bg_hex, min_ratio)
      if not fg_hex or not bg_hex then return fg_hex end
      local function hex_to_rgb(hex)
        hex = hex:gsub("#", "")
        if #hex ~= 6 then return nil end
        return tonumber(hex:sub(1,2), 16), tonumber(hex:sub(3,4), 16), tonumber(hex:sub(5,6), 16)
      end
      local function luminance(r, g, b)
        local function chan(c)
          c = c / 255
          return c <= 0.03928 and c / 12.92 or ((c + 0.055) / 1.055) ^ 2.4
        end
        return 0.2126 * chan(r) + 0.7152 * chan(g) + 0.0722 * chan(b)
      end
      local r1, g1, b1 = hex_to_rgb(fg_hex)
      local r2, g2, b2 = hex_to_rgb(bg_hex)
      if not r1 or not r2 then return fg_hex end

      local l1, l2 = luminance(r1, g1, b1), luminance(r2, g2, b2)
      if l1 < l2 then l1, l2 = l2, l1 end
      if (l1 + 0.05) / (l2 + 0.05) >= (min_ratio or 4.5) then
        return fg_hex
      end

      local target_r, target_g, target_b = 237, 238, 240
      for t = 1, 10 do
        local factor = t / 10
        local nr = r1 + (target_r - r1) * factor
        local ng = g1 + (target_g - g1) * factor
        local nb = b1 + (target_b - b1) * factor
        local cand = string.format("#%02X%02X%02X", math.floor(nr + 0.5), math.floor(ng + 0.5), math.floor(nb + 0.5))
        local cl1 = luminance(math.floor(nr + 0.5), math.floor(ng + 0.5), math.floor(nb + 0.5))
        if cl1 < l2 then cl1, l2 = l2, cl1 end
        if (cl1 + 0.05) / (l2 + 0.05) >= (min_ratio or 4.5) then
          return cand
        end
      end
      return "#EDEEF0"
    end

    local wallust_file = vim.fn.expand("~/.cache/wallust/colors-wallust.lua")
    if vim.fn.filereadable(wallust_file) == 1 then
      local ok, wallust = pcall(dofile, wallust_file)
      if ok and wallust then
        local bg = wallust.color0 or wallust.background
        diff_color = {
          added    = { fg = ensure_contrast(wallust.color2, bg, 4.5), gui = "bold" },
          modified = { fg = ensure_contrast(wallust.color3, bg, 4.5), gui = "bold" },
          removed  = { fg = ensure_contrast(wallust.color1, bg, 4.5), gui = "bold" },
        }
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
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          'branch',
          {
            'diff',
            colored = true,
            diff_color = diff_color,
          },
          'diagnostics'
        },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      tabline = {
        lualine_x = tab_sectionx,
        lualine_y = tab_sectiony,
      }
    })
  end
}
