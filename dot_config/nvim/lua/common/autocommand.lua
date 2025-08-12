local common = require('common')
local b_local = { buffer = 0 }
local winid = vim.api.nvim_get_current_win()
local bufnr = vim.api.nvim_get_current_buf()

local M = {}

function M.go_file()
  local realpath = common.get_terminal_cfile()
  vim.cmd('edit ' .. realpath)
end

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.wo[winid][0].statusline = "%{b:term_title}"
    vim.keymap.set('n', 'gf', M.go_file, b_local)
    vim.cmd.startinsert()
  end,
})
