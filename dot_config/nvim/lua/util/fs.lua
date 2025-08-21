local M = {}

function M.get_absoulte_path(path)
  local expanded = vim.fn.expand(path)
  return vim.fn.fnamemodify(expanded, ":p")
end

function M.make_load_command(path_info)
  print(path_info)
  assert(type(path_info) == "string", "path_info must be a string like 'file.lua:42'")
  local path, line = unpack(vim.split(path_info, ":", { trimempty = true }))
  path = M.get_absoulte_path(path)
  local stat = vim.uv.fs_stat(path)
  assert(stat ~= nil, string.format("File does not exist: %s", path))

  -- path exists
  if line then
    return stat.type, string.format('edit! +%s %s', line, path)
  else
    return stat.type, string.format('edit! %s', path)
  end

end

return M
