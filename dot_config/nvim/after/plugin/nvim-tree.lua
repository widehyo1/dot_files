local common = require("common")
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
        if vim.uv.fs_stat(path).type == "file" then
          return
        end
        vim.fn.execute(common.make_termpath(path))
        vim.bo.filetype = 'floating_window'
        vim.keymap.set('n', '<C-D>', function()
          vim.fn.execute('bp|bd! #')
          vim.api.nvim_win_close(0, true)
        end, { buffer = buf })
      end,
      close_window = false
    })

    local win, buf = buf_util.floating_window(lines, nil, nil, buf_opt)
    buf_util.add_floating_window_callback(win, buf, bookmark_callback)
    buf_util.add_floating_window_callback(win, buf, term_callback)

    -- keymap to write bookmark
    vim.keymap.set('n', '<leader>w', ':write! /home/widehyo/.config/nvim/lua/data/bookmark<CR>', { buffer = buf })

  end,
  {
    nargs = 0,
    desc = "Open bookmark floating window"
  }
)

vim.keymap.set('n', '<leader>B', ':OpenBookmark<CR>')
