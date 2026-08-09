return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    local color_overrides = {}
    local wallust_file = vim.fn.expand("~/.cache/wallust/colors-wallust.lua")
    if vim.fn.filereadable(wallust_file) == 1 then
      local ok, wallust = pcall(dofile, wallust_file)
      if ok and wallust then
        color_overrides = {
          all = {
            base = wallust.background,
            mantle = wallust.color0,
            crust = wallust.background,
            surface0 = wallust.color0,
            surface1 = wallust.color8,
            surface2 = wallust.color7,
            overlay0 = wallust.color7,
            overlay1 = wallust.foreground,
            subtext0 = wallust.foreground,
            subtext1 = wallust.foreground,
            text = wallust.foreground,
            blue = wallust.color4,
            magenta = wallust.color5,
            cyan = wallust.color6,
            green = wallust.color2,
            yellow = wallust.color3,
            red = wallust.color1,
          },
        }
      end
    end

    require("catppuccin").setup({
      transparent_background = true,
      color_overrides = color_overrides,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        telescope = { enabled = true },
        lualine = true,
      },
    })
    vim.cmd.colorscheme "catppuccin"
  end
}
