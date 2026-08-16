return {
  'krivahtoo/silicon.nvim',
  build = './install.sh',
  theme = 'Cappuccin',
  config = function()
    require('silicon').setup({
      theme = 'Dracula',
      font = 'JetBrainsMono Nerd Font',
      window_title = function()
        return "DarkChoclate"
      end,
      output = {
        -- clipboard = false,
      },
      watermark = {
        text = "@darkard2003",
        style = "bold"
      }
    })
  end
}
