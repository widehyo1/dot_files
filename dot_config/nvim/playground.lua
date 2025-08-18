local M = {}

local common = require('common')
local chain = require('util.chain')
local util = require("plugin_util.nvim-tree")
local buf_util = require('util.buf')

local nvim_conf_home = '/home/widehyo/.config/nvim/'

function M.bookmark()
  local bookmark_path = nvim_conf_home .. 'lua/data/bookmark'
  local lines = vim.fn.readfile(bookmark_path)
  local buf_opt = {
    filetype = 'bookmark',
    modifiable = true
  }

  local bookmark_callback = {
    pre_callback = function()
      return lines[vim.fn.line(".")]
    end,
    post_callback = function(path)
      util.load_item(path)
    end
  }

  local term_callback = vim.tbl_deep_extend("force", bookmark_callback, {
    key = 't',
    post_callback = function(path)
      vim.fn.execute(common.make_termpath(path))
    end,
    close_window = false
  })

  local win, buf = buf_util.floating_window(lines, nil, nil, buf_opt)
  buf_util.add_floating_window_callback(win, buf, bookmark_callback)
  buf_util.add_floating_window_callback(win, buf, term_callback)

end

M.bookmark()
