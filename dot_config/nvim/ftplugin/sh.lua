local common = require('common')
local b_local = { buffer = 0 }

vim.keymap.set('n', '<leader>rr', ':!bash %<CR>', b_local)
