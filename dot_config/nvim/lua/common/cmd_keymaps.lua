local silent_noremap = { noremap = true, silent = true }

-- md
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

