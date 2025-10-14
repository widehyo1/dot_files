local chain = require('util.chain')

local M = {}
if vim.g.open_terminal_mode == nil then
  vim.g.open_terminal_mode = 0
end

function M.toggle_open_terminal_mode()
  vim.g.open_terminal_mode = (vim.g.open_terminal_mode + 1) % 4
  M.print_open_terminal_mode()
end

function M.print_open_terminal_mode()
  print(vim.g.open_terminal_mode)
  local terminal_modes = {':sh', ':terminal (cd pwd)', ':terminal', ':terminal (vs)'}
  local joiner = function(acc, cur)
    return acc .. ' | ' .. cur
  end
  for idx, modename in ipairs(terminal_modes) do
    if (idx - 1) == vim.g.open_terminal_mode then
      terminal_modes[idx] = '< ' .. modename .. ' >'
    end
  end
  print(chain.from(terminal_modes)
    :reduce(joiner)
  )
end

-- M.toggle_open_terminal_mode()
print(#vim.fn.getwininfo())
