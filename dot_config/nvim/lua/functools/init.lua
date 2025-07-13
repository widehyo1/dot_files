-- /home/widehyo/.config/nvim/lua/functools/init.lua
local M = {}

function M.map(tbl, func)
  local result = {}
  for i, v in ipairs(tbl) do
    result[i] = func(v, i)
  end
  return result
end

function M.filter(tbl, predicate)
  local result = {}
  for i, v in ipairs(tbl) do
    if predicate(v, i) then
      table.insert(result, v)
    end
  end
  return result
end

function M.reduce(tbl, func, init)
  local acc = init
  for i, v in ipairs(tbl) do
    acc = func(acc, v, i)
  end
  return acc
end

-- Generator utility: wrap table
function M.keys(tbl)
    return coroutine.wrap(function ()
        for key, val in pairs(tbl) do
            coroutine.yield(key)
        end
    end)
end

-- Generator utility: wrap table
function M.values(tbl)
    return coroutine.wrap(function ()
        for key, val in pairs(tbl) do
            coroutine.yield(val)
        end
    end)
end

-- Generator utility: wrap table
function M.items(tbl)
    return coroutine.wrap(function ()
        for key, val in pairs(tbl) do
            coroutine.yield(key, val)
        end
    end)
end

-- Lazy map
function M.map_gen(gen, fn)
  return function()
    local val = gen()
    if val then
        return fn(val)
    end
  end
end

-- Lazy filter
function M.filter_gen(gen, predicate)
  return function()
    while true do
      local val = gen()
      if val == nil then return end
      if predicate(val) then
          return val
      end
    end
  end
end

-- Consume generator to table
function M.collect(gen)
  local result = {}
  for val in gen do
    table.insert(result, val)
  end
  return result
end

function M.collect_kv(gen)
  local result = {}
  for k, v in gen do
    result[k] = v
  end
  return result
end

return M
