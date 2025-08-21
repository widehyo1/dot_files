local lua_util = require('util.lua')
-- local file_info = '~/.bashrc:70'
local file_info = '~/.bashrc'
print(vim.uv.fs_stat(file_info) == nil)
print(vim.uv.fs_stat(file_info).type)
lua_util.print_table(vim.uv.fs_stat(file_info))
-- local file_info = '~/.bashrc'
--
-- local path, line = unpack(vim.split(file_info, ":", { trimempty = true }))
-- local cmd = ''
-- if line then
--   cmd = string.format('edit! +%s %s', line, path)
-- else
--   cmd = string.format('edit! %s', path)
-- end
--
-- print(cmd)
