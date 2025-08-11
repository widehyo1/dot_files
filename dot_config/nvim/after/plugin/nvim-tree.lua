local lua_util = require("util.lua")
local buf_util = require('util.buf')
local util = require("plugin_util.nvim-tree")
local silent_noremap = { noremap = true, silent = true }

local nvim_conf_home = '/home/widehyo/.config/nvim/'

-- nvimtree
vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeToggle<CR>', silent_noremap)
vim.keymap.set('n', '<leader>.', util.update_nvim_tree)
vim.keymap.set('n', '<leader>ft', function() util.load_item(nvim_conf_home .. 'ftplugin/') end)
vim.keymap.set('n', '<leader>after', function() util.load_item(nvim_conf_home .. 'after/') end)
vim.keymap.set('n', '<leader>lua', function() util.load_item(nvim_conf_home .. 'lua/') end)

vim.api.nvim_create_user_command(
  "OpenBookmark",
  function(opts)
    local bookmark_path = nvim_conf_home .. 'lua/data/bookmark'
    local lines = vim.fn.readfile(bookmark_path)
    local buf_opt = {
      filetype = 'bookmark',
      modifiable = true
    }

    local select_bookmark = function ()
      return lines[vim.fn.line('.')]
    end

    local load_bookmark = function(item)
      util.load_item(item)
    end

    local win, buf = buf_util.floating_window(lines, nil, nil, buf_opt)
    buf_util.add_floating_window_callback(win, buf, select_bookmark, load_bookmark)

  end,
  {
    nargs = 0,
    desc = "Open bookmark floating window"
  }
)

vim.keymap.set('n', '<leader>B', ':OpenBookmark<CR>')
