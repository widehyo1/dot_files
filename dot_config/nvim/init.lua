vim.g.mapleader = ","

require('common.options')
require('common.keymaps')

-- emmet
require('lsp.emmet')

-- custom_keymaps
require('common.custom')

-- netrw
-- vim.g.netrw_liststyle = 3
-- vim.api.nvim_set_keymap('n', '<leader>n', ':20Lex<CR>', silent_noremap)
-- vim.api.nvim_set_keymap('n', '<leader>.', ':exe ":20Lex " .. expand("%:h")<CR>', { noremap = true, silent = false })

-- lazy.nvim
require('config.lazy')
