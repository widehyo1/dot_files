local common = require('common')
local cmd_window = require('util.buf.cmd_window')
local fw_util = require('autocmd.floating_window')
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
    nargs = "?",
    desc = "Open buffer menu with optional search text"
  }
)
vim.keymap.set('n', '<leader><leader>s', ':BufferMenu ')

vim.api.nvim_create_user_command(
  'SearchAcrossFiles',
  function(opts)
    local search_text = opts.fargs[1]
    common.search_across_files(search_text)
  end,
  {
    nargs = "?",
    desc = "Open search results in the project with optional search text(default `last search`)"
  }
)
vim.keymap.set('n', '<leader><leader><C-F>', ':SearchAcrossFiles ')

vim.api.nvim_create_user_command(
  'CopyToPwd',
  function(opts)
    local filename = opts.fargs[1]
    common.copy_to_pwd(filename)
  end,
  {
    nargs = "?",
    desc = "paste current buffer to present working directory",
    complete = "file"
  }
)
vim.keymap.set('n', '<leader>cpwd', ':CopyToPwd ')

vim.api.nvim_create_user_command(
  'FloatingExecuteCommand',
  function(opts)
    local cmd = opts.fargs[1]
    cmd_window.command_window(cmd)
  end,
  {
    nargs = 1,
    desc = "open floating window for vim command"
  }
)
vim.keymap.set('n', '<leader>fwe', ':FloatingExecuteCommand ')

vim.api.nvim_create_user_command(
  'FloatingSystemCommand',
  function(opts)
    local cmd = opts.fargs[1]
    cmd_window.system_window(cmd)
  end,
  {
    nargs = 1,
    desc = "open floating window for system(bash) command"
  }
)
vim.keymap.set('n', '<leader>fws', ':FloatingSystemCommand ')

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

vim.keymap.set('n', '<leader>msg', cmd_window.message_window)
vim.keymap.set('n', '<leader>map', cmd_window.map_window)
vim.keymap.set('n', '<leader>autocmd', cmd_window.autocmd_window)
vim.keymap.set('n', '<leader>hi', cmd_window.highlight_window)

-- vim.keymap.set('n', '<C-D>', common.floating_terminal)

vim.keymap.set('n', '<leader>wb', fw_util.toggle_focus)

vim.keymap.set('n', '<space>cd', common.cd_current_line)

-- terminal
vim.keymap.set('n', '<C-D>', common.open_terminal)
vim.keymap.set('n', '<space><space><space>', common.toggle_open_terminal_mode)
vim.keymap.set('n', '<space><space>0', function() common.select_open_terminal_mode(0) end)
vim.keymap.set('n', '<space><space>1', function() common.select_open_terminal_mode(1) end)
vim.keymap.set('n', '<space><space>2', function() common.select_open_terminal_mode(2) end)

vim.o.tabline =  '%!v:lua.tabline_buffers()'

