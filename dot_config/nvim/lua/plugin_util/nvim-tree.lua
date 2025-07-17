local M = {}
local api = require("nvim-tree.api")

function M.get_absolute_path()
  local node = api.tree.get_node_under_cursor()
  return node.absolute_path
end

function M.get_directory_path()
  local abspath = M.get_absolute_path()
  local targetpath = abspath
  if vim.fn.isdirectory(abspath) ~= 1 then
    targetpath = vim.fs.dirname(abspath)
  end
  return targetpath
end

function M.cd_node()
  local targetpath = M.get_directory_path()
  vim.cmd(":cd " .. targetpath)
  print(targetpath)
end

return M
