local util = require("plugin_util.nvim-tree")

local buffer_noremap = { noremap = true, silent = true, buffer = true, }

vim.keymap.set('n', '<leader>cd', util.cd_node, buffer_noremap)
vim.keymap.set('n', '<leader>C', util.change_root, buffer_noremap)
