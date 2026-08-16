return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    local langs = {
      "go",
      "zig",
      "c",
    }
    ts.install(langs)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*", -- Trigger on ALL filetypes
      callback = function(args)
        local bufnr = args.buf

        local ft = vim.bo[bufnr].filetype
        local lang = vim.treesitter.language.get_lang(ft) or ft

        pcall(vim.treesitter.start, bufnr, lang)
      end,
    })
  end,
}
