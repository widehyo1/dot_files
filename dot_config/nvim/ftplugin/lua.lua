local cmd_window = require('util.buf.cmd_window')

local bufnr = vim.api.nvim_get_current_buf()
local b_local = { buffer = 0 }

vim.bo[bufnr].tabstop = 2
vim.bo[bufnr].shiftwidth = 2
vim.bo[bufnr].softtabstop = 2

vim.keymap.set('n', '<leader>rr', ':source %<CR>', b_local)
vim.keymap.set('n', '<leader>rf', cmd_window.run_lua, b_local)
