local b_local = { buffer = 0 }

-- sql
vim.keymap.set('n', '<leader>sf', ':! sqlformat --reindent --keywords upper --identifiers lower --comma_first true -<CR>', b_local)
