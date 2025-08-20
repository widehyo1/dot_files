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

vim.o.mouse = ""
vim.o.number = true
vim.o.showmatch = true
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.swapfile = false
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.showcmd = true
vim.o.autoread = true
vim.o.cursorline = true
vim.o.list = true
vim.o.showtabline = 2
vim.o.tags = './.tags;/'
vim.o.listchars = "tab:>-,trail:«,space:•,lead:»"
