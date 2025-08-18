local common = require('common')
local tree = require('custom_tree')

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

vim.keymap.set('n', '<space>`', 'yiwcw``"0P')
vim.keymap.set('v', '<space>`', 'ygvc``"0P')
vim.keymap.set('n', '<space>"', 'yiwcw"""0P')
vim.keymap.set('v', '<space>"', 'ygvc"""0P')
vim.keymap.set('n', '<space>\'', 'yiwcw\'\'"0P')
vim.keymap.set('v', '<space>\'', 'ygvc\'\'"0P')
vim.keymap.set('n', '<space>(', 'yiwcw()"0P')
vim.keymap.set('v', '<space>(', 'ygvc()"0P')
vim.keymap.set('n', '<space>[', 'yiwcw[]"0P')
vim.keymap.set('v', '<space>[', 'ygvc[]"0P')
vim.keymap.set('n', '<space><', 'yiwcw<>"0P')
vim.keymap.set('v', '<space><', 'ygvc<>"0P')
vim.keymap.set('n', '<space>{', 'yiwcw{}"0P')
vim.keymap.set('v', '<space>{', 'ygvc{}"0P')

vim.keymap.set('n', '<leader>msg', common.message)
