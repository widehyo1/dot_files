local lua_util = require('util.lua')
local M = {}

function M.get_terminal_cfile()
  local expand = vim.fn.expand
  local cfile = expand('<cfile>')
  return string.sub(cfile, 1, string.len(cfile) - 1)
end
