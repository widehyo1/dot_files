local common = require('common')
local b_local = { buffer = 0 }

local bufnr = vim.api.nvim_get_current_buf()

vim.bo[bufnr].tabstop = 2
vim.bo[bufnr].shiftwidth = 2
vim.bo[bufnr].softtabstop = 2

common.add_snippet("func", "function ${1:funcname}{\n  ${2:content}\n}", b_local)
common.add_snippet("edfunc", "export default function ${1:funcname}{\n  ${2:content}\n}", b_local)
