local cmd_window = require('util.buf.cmd_window')

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

-- gvpr
vim.api.nvim_set_keymap('n', '<leader>gvs', ':e ~/script.gvpr<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>gvt', ':e ~/temp.dot<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>gvp', ':r ! gvpr -f ~/script.gvpr ~/temp.dot<CR>', silent_noremap)
vim.api.nvim_set_keymap('v', '<leader>gvp', ':! gvpr -f ~/script.gvpr<CR>', silent_noremap)

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

-- httpyac
vim.api.nvim_set_keymap('n', '<leader>hts', ':e ~/script.http<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>htt', ':e ~/request.json<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>hty', ':let @+ = system("cd ~ && httpyac ~/script.http --all")<CR>', silent_noremap)
vim.api.nvim_set_keymap('n', '<leader>htp', ':r ! cd ~ && httpyac ~/script.http --all<CR>', silent_noremap)

-- floating window
vim.keymap.set('n', '<leader>af', cmd_window.awk_window)
vim.keymap.set('n', '<leader>gvf', cmd_window.gvpr_window)
vim.keymap.set('n', '<leader>jf', cmd_window.jq_window)
vim.keymap.set('n', '<leader>cf', cmd_window.curl_window)
vim.keymap.set('n', '<leader>htf', cmd_window.httpyac_window)

-- vim.api.nvim_set_keymap('n', '<leader>pg', ':PyGrep ', silent_noremap)

