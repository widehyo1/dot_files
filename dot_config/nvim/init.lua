vim.g.mapleader = ","

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
vim.o.listchars = "tab:>-,trail:«,space:•,lead:»"

local silent_noremap = { noremap = true, silent = true }

vim.api.nvim_set_keymap('i', 'jj', '<ESC>', silent_noremap)

vim.api.nvim_set_keymap('n', '<leader>rc', ':e ~/.config/nvim/init.lua<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>vrc', ':e ~/.vimrc<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>brc', ':e ~/.bashrc<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>plugin', ':e ~/.config/nvim/lua/plugins/init.lua<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>md', ':e $TODAYMD<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>h', ':noh<CR><ESC>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader><C-D>', '<C-D> <C-D>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>H', 'H', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>L', 'L', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>`v', '/`/-1<CR>V?`?+1<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>`y', '/`/-1<CR>V?`?+1<CR>y', silent_noremap)

-- awk
vim.api.nvim_set_keymap('n', '<leader>as', ':e ~/script.awk<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>at', ':e ~/temp.txt<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>ay', ':let @+ = system("awk -f ~/script.awk ~/temp.txt")<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>ap', ':r ! awk -f ~/script.awk ~/temp.txt<CR>', silent_noremap)
vim.api.nvim_set_keymap('v', '<leader>ap', ':! awk -f ~/script.awk<CR>', silent_noremap)

-- jq
vim.api.nvim_set_keymap('n', '<leader>js', ':e ~/script.jq<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>jt', ':e ~/temp.json<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>jy', ':let @+ = system("jq -r -f ~/script.jq ~/temp.json")<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>jp', ':r ! jq -r -f ~/script.jq ~/temp.json<CR>', silent_noremap)
vim.api.nvim_set_keymap('v', '<leader>jp', ':! jq -r -f ~/script.jq<CR>', silent_noremap)
vim.api.nvim_set_keymap('v', '<leader>jf', ':! jq .<CR>', silent_noremap)

-- curl
vim.api.nvim_set_keymap('n', '<leader>cs', ':e ~/script.curl<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>ct', ':e ~/request.json<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>cy', ':let @+ = system("curl --config ~/script.curl")<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>cp', ':r ! curl --config ~/script.curl<CR>', silent_noremap)

-- sql
vim.api.nvim_set_keymap('n', '<leader>sf', ':! sqlformat --reindent --keywords upper --identifiers lower --comma_first true -<CR>', silent_noremap)

-- python
vim.api.nvim_set_keymap('n', '<leader>pf', ':! black %<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>plf', ':! bash ~/.cli/shell/pylog_format_vimfile.sh<CR>', silent_noremap)
-- vim.api.nvim_set_keymap('n', '<leader>pg', ':PyGrep ', silent_noremap)

-- editor
vim.api.nvim_set_keymap('n', '<C-Up>', ':m .-2<CR>==', silent_noremap)
vim.api.nvim_set_keymap('n', '<C-Down>', ':m .+1<CR>==', silent_noremap)

-- buffer
vim.api.nvim_set_keymap('n', 'L', ':bn!<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', 'H', ':bp!<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>q', ':bp<bar>bd #<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>ls', ':ls<CR>', silent_noremap)

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
vim.api.nvim_set_keymap('n', '<C-D>', ':susp<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>d', ':%s/<CR>//g<CR>', silent_noremap)

-- path
vim.api.nvim_set_keymap('n', '<leader>cd', ':cd %:h<bar>pwd<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>g', ':echo expand("%:p")<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>pp', ':let @+ = expand("%:p")<CR>', silent_noremap)

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

-- load scripts
local common = require('common')
vim.keymap.set('n', '<leader><leader>p', common.copy_pwd)
vim.keymap.set('n', '<F5>', common.toggle_snake_camel)

local tree = require('custom_tree')
vim.keymap.set('n', '<leader>tn', tree.print_treesitter_node_path)

-- lazy.nvim
require('config.lazy')
