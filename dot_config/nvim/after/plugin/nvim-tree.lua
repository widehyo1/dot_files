local lua_util = require("util.lua")
local buf_util = require('util.buf')
local util = require("plugin_util.nvim-tree")
local silent_noremap = { noremap = true, silent = true }

-- nvimtree
vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeToggle<CR>', silent_noremap)
vim.keymap.set('n', '<leader>.', function()
  if not util.is_visible() then
    vim.cmd(":NvimTreeClose")
  end
  vim.cmd(":NvimTreeFindFile!")
end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function()
    local buffer_noremap = lua_util.concat(silent_noremap, { buffer = true })
    vim.keymap.set('n', '<leader>cd', util.cd_node, buffer_noremap)
  end
})

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
