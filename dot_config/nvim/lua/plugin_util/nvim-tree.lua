local M = {}
local api = require("nvim-tree.api")
local view = require("nvim-tree.view")

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

function M.is_visible()
  return view.is_visible()
end

function M.load_item(item)
  if vim.uv.fs_stat(item).type == "file" then
    vim.cmd('edit! ' .. item)
  else
    if view.is_visible() then
      vim.cmd(":NvimTreeClose")
    end
    api.tree.open({ path = item })
  end
end

return M
