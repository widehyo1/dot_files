local common = require('common')
local b_local = { buffer = 0 }

local bufnr = vim.api.nvim_get_current_buf()

vim.bo[bufnr].tabstop = 2
vim.bo[bufnr].shiftwidth = 2
vim.bo[bufnr].softtabstop = 2

common.add_snippet("while", "while ${1:condition}\n  ${2:statement}\nendwhile", b_local)
common.add_snippet("for", "for ${1:varname} in ${2:listexpression}\n  ${3:statement}\nendfor", b_local)
common.add_snippet("function", "function! ${1:Funcname()}\n  ${2:statement}\nendfunction", b_local)

vim.keymap.set('n', '<leader>rr', ':source %<CR>', b_local)
