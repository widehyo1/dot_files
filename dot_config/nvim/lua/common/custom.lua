local common = require('common')
local surround = require('util.surround')

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
vim.keymap.set('n', 'q:', common.command_menu)

vim.api.nvim_create_user_command(
  'SurroundBacktick',
  function(opts)
    surround.backtick()
  end,
  { range = 0 }
)

vim.keymap.set('n', '<space>`', ':SurroundBacktick<CR>')
vim.keymap.set('v', '<space>`', ':SurroundBacktick<CR>')

vim.api.nvim_create_user_command(
  'SurroundQuote',
  function(opts)
    surround.quote()
  end,
  { range = 0 }
)

vim.keymap.set('n', "<space>'", ':SurroundQuote<CR>')
vim.keymap.set('v', "<space>'", ':SurroundQuote<CR>')

vim.api.nvim_create_user_command(
  'SurroundDoubleQuote',
  function(opts)
    surround.double_quote()
  end,
  { range = 0 }
)

vim.keymap.set('n', '<space>"', ':SurroundDoubleQuote<CR>')
vim.keymap.set('v', '<space>"', ':SurroundDoubleQuote<CR>')

vim.api.nvim_create_user_command(
  'SurroundRoundBraket',
  function(opts)
    surround.round_braket()
  end,
  { range = 0 }
)

vim.keymap.set('n', '<space>(', ':SurroundRoundBraket<CR>')
vim.keymap.set('v', '<space>(', ':SurroundRoundBraket<CR>')

vim.api.nvim_create_user_command(
  'SurroundSquareBraket',
  function(opts)
    surround.square_braket()
  end,
  { range = 0 }
)

vim.keymap.set('n', '<space>[', ':SurroundSquareBraket<CR>')
vim.keymap.set('v', '<space>[', ':SurroundSquareBraket<CR>')

vim.api.nvim_create_user_command(
  'SurroundAngleBraket',
  function(opts)
    surround.angle_braket()
  end,
  { range = 0 }
)

vim.keymap.set('n', '<space><', ':SurroundAngleBraket<CR>')
vim.keymap.set('v', '<space><', ':SurroundAngleBraket<CR>')

vim.api.nvim_create_user_command(
  'SurroundCurlyBraket',
  function(opts)
    surround.curly_braket()
  end,
  { range = 0 }
)

vim.keymap.set('n', '<space>{', ':SurroundCurlyBraket<CR>')
vim.keymap.set('v', '<space>{', ':SurroundCurlyBraket<CR>')
