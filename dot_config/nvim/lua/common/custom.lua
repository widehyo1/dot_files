local common = require('common')
local surround = require('util.surround')
local tree = require('custom_tree')
local buf_util = require('util.buf')

vim.keymap.set('n', '<leader>tn', tree.print_treesitter_node_path)

vim.keymap.set('n', '<leader><leader><leader>', common.buffer_menu)
vim.api.nvim_create_user_command(
  'BufferMenu',
  function(opts)
    local search_text = opts.fargs[1]
    common.buffer_menu(search_text)
  end,
  {
    nargs = 1,
    desc = "Open buffer menu with optional search text"
  }
)
vim.keymap.set('n', '<leader><leader>s', ':BufferMenu ')
-- vim.keymap.set('n', 'q:', common.command_menu)


vim.api.nvim_create_user_command(
  "OpenBookmark",
  function(opts)
    local bookmark_path = '/home/widehyo/.config/nvim/lua/data/bookmark'
    local lines = vim.fn.readfile(bookmark_path)
    local buf_opt = { filetype = 'bookmark' }

    local select_bookmark = function ()
      return lines[vim.fn.line('.')]
    end

    local load_bookmark = function(item)
      if vim.uv.fs_stat(item).type == "file" then
        vim.cmd('edit! ' .. item)
      else
        local view = require("nvim-tree.view")
        local api = require("nvim-tree.api")
        if view.is_visible() then
          vim.cmd(":NvimTreeClose")
        end
        api.tree.open({ path = item })
      end
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
