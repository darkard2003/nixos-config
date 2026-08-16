local km = vim.keymap.set
km("i", "jk", "<esc>", { desc = "jk to esc" })

vim.g.mapleader = " "

km("n", "<leader><leader>x", ":source %<CR>", { desc = "source the current file" })
km({ 'n', 'v' }, "<leader>x", ":.lua<CR>", { desc = "source the current line" })

km("n", "<C-h>", "<C-w><C-h>", { desc = "Better left movement" })
km("n", "<C-j>", "<C-w><C-j>", { desc = "Better down movement" })
km("n", "<C-k>", "<C-w><C-k>", { desc = "Better up movement" })
km("n", "<C-l>", "<C-w><C-l>", { desc = "Better right movement" })

local function set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

local term_group = vim.api.nvim_create_augroup("TerminalSettings", { clear = true })

vim.api.nvim_create_autocmd('TermOpen', {
  group = term_group,
  pattern = '*',
  callback = set_terminal_keymaps,
})
