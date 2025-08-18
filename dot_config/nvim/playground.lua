local M = {}

local common = require('common')
local chain = require('util.chain')
local util = require("plugin_util.nvim-tree")
local buf_util = require('util.buf')

local nvim_conf_home = '/home/widehyo/.config/nvim/'

function M.floating_terminal()
  local win, buf = buf_util.floating_window()
  vim.fn.execute('terminal')
  vim.keymap.set('n', '<C-D>', function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf })
end

M.floating_terminal()
