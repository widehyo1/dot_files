local surround = require('util.surround')

vim.api.nvim_create_user_command(
  'SurroundBacktick',
  function(opts)
    surround.backtick()
  end,
  { range = 0 }
)

vim.keymap.set('n', '<space>`', ':SurroundBacktick<CR>')
vim.keymap.set('v', '<space>`', ':SurroundBacktick<CR>')
