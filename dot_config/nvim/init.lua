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
vim.o.clipboard = "unnamedplus"
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.showcmd = true
vim.o.autoread = true
vim.o.cursorline = true
vim.o.list = true
vim.o.listchars = "tab:>-,trail:«,space:•,lead:»"

vim.api.nvim_set_keymap('i', 'jj', '<ESC>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>rc', ':e ~/.config/nvim/init.lua<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>brc', ':e ~/.bashrc<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>md', ':e $TODAYMD<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>h', ':noh<CR><ESC>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader><C-D>', '<C-D> <C-D>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>H', 'H', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>L', 'L', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>`v', '/`/-1<CR>V?`?+1<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>`y', '/`/-1<CR>V?`?+1<CR>y', { noremap = true, silent = true })

-- awk
vim.api.nvim_set_keymap('n', '<leader>as', ':e ~/script.awk<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>at', ':e ~/temp.txt<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ay', ':let @+ = system("awk -f ~/script.awk ~/temp.txt")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ap', ':r ! awk -f ~/script.awk ~/temp.txt<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ap', ':! awk -f ~/script.awk<CR>', { noremap = true, silent = true })

-- jq
vim.api.nvim_set_keymap('n', '<leader>js', ':e ~/script.jq<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>jt', ':e ~/temp.json<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>jy', ':let @+ = system("jq -r -f ~/script.jq ~/temp.json")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>jp', ':r ! jq -r -f ~/script.jq ~/temp.json<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>jp', ':! jq -r -f ~/script.jq<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>jf', ':! jq .<CR>', { noremap = true, silent = true })

-- curl
vim.api.nvim_set_keymap('n', '<leader>cs', ':e ~/script.curl<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ct', ':e ~/request.json<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cy', ':let @+ = system("curl --config ~/script.curl")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cp', ':r ! curl --config ~/script.curl<CR>', { noremap = true, silent = true })

-- sql
vim.api.nvim_set_keymap('n', '<leader>sf', ':! sqlformat --reindent --keywords upper --identifiers lower --comma_first true -<CR>', { noremap = true, silent = true })

-- python
vim.api.nvim_set_keymap('n', '<leader>pf', ':! black %<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>plf', ':! bash ~/.cli/shell/pylog_format_vimfile.sh<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>pg', ':PyGrep ', { noremap = true, silent = true })

-- editor
vim.api.nvim_set_keymap('n', '<C-Up>', ':m .-2<CR>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Down>', ':m .+1<CR>==', { noremap = true, silent = true })

-- buffer
vim.api.nvim_set_keymap('n', 'L', ':bn!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'H', ':bp!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', ':bp<bar>bd #<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ls', ':ls<CR>', { noremap = true, silent = true })

-- window
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ws', '<C-W><C-S>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wv', '<C-W><C-V>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wns', ':new<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wnv', ':vnew<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wwr', '<C-W>=', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wwv', '<C-W>_', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wwh', '<C-W><bar>', { noremap = true, silent = true })

-- misc
vim.api.nvim_set_keymap('n', '<C-D>', ':susp<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>d', ':%s/\r//g<CR>', { noremap = true, silent = true })

-- path
vim.api.nvim_set_keymap('n', '<leader>cd', ':cd %:h<bar>pwd<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>g', ':echo expand("%:p")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>pp', ':let @+ = expand("%:p")<CR>', { noremap = true, silent = true })


-- netrw
vim.g.netrw_liststyle = 3
vim.api.nvim_set_keymap('n', '<leader>n', ':20Lex<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>.', ':exe ":20Lex " .. expand("%:h")<CR>', { noremap = true, silent = false })

-- load scripts
local common = require('common')
vim.keymap.set('n', '<leader><leader>p', common.copy_pwd)
vim.keymap.set('n', '<F5>', common.toggle_snake_camel)

local tree = require('custom_tree')
vim.keymap.set('n', '<leader>tn', tree.print_treesitter_node_path)
