local common = require('common')
local cmd_window = require('util.buf.cmd_window')

local b_local = { buffer = 0 }

vim.keymap.set('n', '<leader>rr', ':!bash %<CR>', b_local)
vim.keymap.set('n', '<leader>rf', cmd_window.run_bash, b_local)
