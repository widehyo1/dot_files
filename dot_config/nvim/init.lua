vim.g.mapleader = ","
vim.g.open_terminal_mode = 0

require('common.options')
require('common.keymaps')

-- emmet
require('lsp.emmet')

-- custom_keymaps
require('common.custom')

-- autocmd
require('autocmd')
local autocmd_custom = require('autocmd.custom')
local fw_config = {}
autocmd_custom.fw_setup(fw_config)

-- netrw
vim.g.netrw_liststyle = 3

-- lazy.nvim
require('config.lazy')
