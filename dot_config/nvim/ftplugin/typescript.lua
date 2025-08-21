local common = require('common')
local cmd_window = require('util.buf.cmd_window')

local b_local = { buffer = 0 }

local bufnr = vim.api.nvim_get_current_buf()

vim.bo[bufnr].tabstop = 2
vim.bo[bufnr].shiftwidth = 2
vim.bo[bufnr].softtabstop = 2

common.add_snippet("func", "function ${1:funcname}{\n  ${2:content}\n}", b_local)
common.add_snippet("edfunc", "export default function ${1:funcname}{\n  ${2:content}\n}", b_local)

vim.keymap.set('n', '<leader>rr', ':!node %<CR>', b_local)
vim.keymap.set('n', '<leader>rf', cmd_window.run_node, b_local)
