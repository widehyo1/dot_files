chain = require('util.chain')

function _G.tabline_buffers()
  local buf_listed = function(buf) return buf.listed == 1 end
  local get_bufname = function(buf)
    local name = ''
    if buf.name == '' then
      name = '[No Name]'
    else
      name = vim.fn.fnamemodify(buf.name, ":t")
    end
    if buf.changed == 1 then
      name = name .. ' +'
    end
    return name
  end

  local joiner = function(acc, cur)
    return acc .. ' | ' .. cur
  end

  local buf_name_str = chain.from(vim.fn.getbufinfo())
    :filter(buf_listed)
    :apply(get_bufname)
    :reduce(joiner)

  return buf_name_str
end

vim.o.showtabline = 2
vim.o.tabline = '%!v:lua.tabline_buffers()'

-- print(statusline_buffers())
