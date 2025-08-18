local silent_noremap = { noremap = true, silent = true }

vim.api.nvim_set_keymap('i', 'jj', '<ESC>', silent_noremap)
vim.api.nvim_set_keymap('t', '<C-Q>', '<C-\\><C-n>', silent_noremap)

vim.api.nvim_set_keymap('n', '<leader>rc', ':e ~/.config/nvim/init.lua<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>vrc', ':e ~/.vimrc<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>brc', ':e ~/.bashrc<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>play', ':e ~/.config/nvim/playground.lua<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>plugin', ':e ~/.config/nvim/lua/plugins/init.lua<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>book', ':e ~/.config/nvim/lua/data/bookmark<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>md', ':e $TODAYMD<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>keymap', ':e /home/widehyo/.config/nvim/lua/common/keymaps.lua<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>option', ':e /home/widehyo/.config/nvim/lua/common/options.lua<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>custom', ':e /home/widehyo/.config/nvim/lua/common/custom.lua<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>h', ':noh<CR><ESC>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>H', 'H', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>L', 'L', silent_noremap)

-- editor
vim.api.nvim_set_keymap('n', '<C-Up>', ':m .-2<CR>==', silent_noremap)
vim.api.nvim_set_keymap('n', '<C-Down>', ':m .+1<CR>==', silent_noremap)

-- buffer
vim.api.nvim_set_keymap('n', 'L', ':bn!<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', 'H', ':bp!<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>q', ':bp<bar>bd! #<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>ls', ':ls<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>bf', ':bf<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>bl', ':bl<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>bdf', ':1,.-1bd!<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>bdl', ':.+1,$bd!<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>bonly', ':1,.-1bd!<Bar>.+1,$bd!<CR>', silent_noremap)

-- window
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W>h', silent_noremap)
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W>l', silent_noremap)
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W>j', silent_noremap)
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W>k', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>ws', '<C-W><C-S>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>wv', '<C-W><C-V>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>wns', ':new<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>wnv', ':vnew<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>wwr', '<C-W>=', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>wwv', '<C-W>_', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>wwh', '<C-W><bar>', silent_noremap)

-- misc
vim.api.nvim_set_keymap('n', '<C-Q>', ':terminal<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader><C-Q>', ':cd %:h<bar>terminal<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>d', ':%s/<C-V><CR>//g<CR>', silent_noremap)

-- path
vim.api.nvim_set_keymap('n', '<leader>cd', ':cd %:h<bar>pwd<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>g', ':echo expand("%:p")<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>pp', ':let @+ = expand("%:p")<CR>', silent_noremap)

require('common.cmd_keymaps')
