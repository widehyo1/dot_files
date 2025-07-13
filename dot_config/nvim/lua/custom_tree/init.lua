local M = {}

function M.print_treesitter_node_path()
  local ts = vim.treesitter
  local parser = ts.get_parser(0)
  if not parser then
    print("No treesitter parser for this buffer")
    return
  end

  local tree = parser:parse()[1]
  local root = tree:root()

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local node = root:named_descendant_for_range(row, col, row, col)
  if not node then
    print("No node found at cursor")
    return
  end

  local path = {}
  while node do
    table.insert(path, 1, node:type())
    node = node:parent()
  end

  print("Tree-sitter node path:")
  print(table.concat(path, " → "))
end

return M
