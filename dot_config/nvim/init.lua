vim.g.mapleader = ","

require('common.options')
require('common.keymaps')

-- custom_keymaps
require('common.custom')

-- clipboard in windows terminal
vim.o.clipboard = "unnamedplus"

-- clipboard in wezterm
-- local osc52 = require('vim.ui.clipboard.osc52')
-- vim.g.clipboard = {
--     name = 'OSC-52',
--     copy = {
--         ['+'] = osc52.copy('+'),
--         ['*'] = osc52.copy('*'),
--     },
--     paste = {
--         ['+'] = osc52.paste('+'),
--         ['*'] = osc52.paste('*'),
--     },
-- }
--
-- vim.keymap.set('n', '<leader>y', '"+y', silent_noremap)
-- vim.keymap.set('v', '<leader>y', '"+y', silent_noremap)
-- vim.keymap.set('n', '<leader>p', '"+p', silent_noremap)


-- netrw
-- vim.g.netrw_liststyle = 3
-- vim.api.nvim_set_keymap('n', '<leader>n', ':20Lex<CR>', silent_noremap)
-- vim.api.nvim_set_keymap('n', '<leader>.', ':exe ":20Lex " .. expand("%:h")<CR>', { noremap = true, silent = false })


local tree = require('custom_tree')
vim.keymap.set('n', '<leader>tn', tree.print_treesitter_node_path)

-- lazy.nvim
require('config.lazy')
