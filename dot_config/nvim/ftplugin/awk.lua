local common = require('common')
local b_local = { buffer = 0 }

local bufnr = vim.api.nvim_get_current_buf()

vim.bo[bufnr].tabstop = 2
vim.bo[bufnr].shiftwidth = 2
vim.bo[bufnr].softtabstop = 2

common.add_snippet("begin", "BEGIN {\n  ${1:content}\n}", b_local)
common.add_snippet("end", "END {\n  ${1:content}\n}", b_local)
common.add_snippet("for", "for (${1:i = 1; i <= NF; i++}) {}", b_local)
common.add_snippet("forarr", 'for (idx in arr) { print "idx: " idx " arr[idx]: " arr[idx] }', b_local)
common.add_snippet("split", "split(${1:str}, ${2:arr}, ${3:sep})", b_local)
common.add_snippet("strip", 'function strip(str) {\n  gsub(/^\\s|\\s\\$/, "", str)\n  return str\n}', b_local)
common.add_snippet("gsub", "gsub(${1:regex}, ${2:replace}, ${3:str})", b_local)
common.add_snippet("rindex", "function rindex(hay, needle,    arr, lastToken) {\n  lastToken = arr[split(hay, arr, needle)]\n  return length(hay) - length(needle) - length(lastToken) + 1\n}", b_local)
common.add_snippet("include", '@include "common"', b_local)
