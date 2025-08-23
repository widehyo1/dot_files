local M = {}

local EMPTY_MSG = "table is empty"

function M.filter(tbl, predicate)
  local filtered = {}
  for _, v in ipairs(tbl) do
    if predicate(v) then
      table.insert(filtered, v)
    end
  end
  return filtered
end

function M.filter_dict(tbl, predicate)
  local filtered = {}
  for k, v in pairs(tbl) do
    if predicate(v) then
      filtered[k] = v
    end
  end
  return filtered
end

function M.map(tbl, mapper)
  local mapped = {}
  for _, v in ipairs(tbl) do
    table.insert(mapped, mapper(v))
  end
  return mapped
end

function M.map_dict(tbl, mapper)
  local mapped = {}
  for k, v in pairs(tbl) do
    mapped[k] = mapper(v)
  end
  return mapped
end

function M.apply(tbl, mapper)
  for i, v in ipairs(tbl) do
    tbl[i] = mapper(v)
  end
  return tbl
end

function M.apply_dict(tbl, mapper)
  for k, v in pairs(tbl) do
    tbl[k] = mapper(v)
  end
  return tbl
end

function M.concat(tbl1, tbl2)
  return vim.tbl_extend("force", tbl1, tbl2)
end

function M.default(target, default_value)
  return target or default_value
end

function M.keyval_name_fmt(key, val)
  return string.format("key: %s, value: %s", tostring(key), tostring(val))
end

function M.keyval_fmt(key, val)
  return tostring(key) .. ": " .. tostring(val)
end

function M.print_table(tbl, sep, formatter)
  -- Set default separator if not provided
  sep = M.default(sep, ", ")

  -- Set default formatter if not provided
  formatter = M.default(formatter, M.keyval_name_fmt)

  local formatted_items = {}
  for k, v in pairs(tbl) do
    table.insert(formatted_items, formatter(k, v))
  end

  print(table.concat(formatted_items, sep))
end

function M.print_table_lazy(tbl, sep, formatter)
  -- Set default separator if not provided
  sep = M.default(sep, ", ")

  -- Set default formatter if not provided
  formatter = M.default(formatter, M.keyval_name_fmt)

  -- coroutine
  local co = coroutine.wrap(function()
    for k, v in pairs(tbl) do
      coroutine.yield(formatter(k, v))
    end
  end)

  local first_item = co() -- get first item
  if first_item == nil then -- empty table
    io.write(EMPTY_MSG)
    return
  end

  io.write(first_item) -- Print the first item *once*, no leading separator
  -- print item with coroutine
  while true do
    local value = co() -- yield next value
    if value == nil then -- exit
      break
    end
    io.write(sep) -- print seperator
    io.write(value) -- print value
  end
end

function M.extend(tbl1, tbl2)
  return vim.tbl_deep_extend("force", tbl1, tbl2)
end

function M.lstrip(s)
  return s:gsub("^%s*", "")
end

function M.rstrip(s)
  return s:gsub("%s*$", "")
end

function M.strip(s)
  s = s:gsub("^%s*", "")
  s = s:gsub("%s*$", "")
  return s
end

return M
