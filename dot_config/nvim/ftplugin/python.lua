local common = require('common')
local cmd_window = require('util.buf.cmd_window')
local b_local = { buffer = 0 }

common.add_snippet("main", "def main():\n    ${2:# content}\n\nif __name__ == '__main__':\n    ${1:main()}", b_local)

-- python
vim.keymap.set('n', '<leader>pf', ':! black %<CR>', b_local)
vim.keymap.set('n', '<leader>plf', ':! bash ~/.cli/shell/pylog_format_vimfile.sh<CR>', b_local)
-- vim.api.nvim_set_keymap('n', '<leader>pg', ':PyGrep ', silent_noremap)

vim.keymap.set('n', '<leader>rr', ':!python3 %<CR>', b_local)
vim.keymap.set('n', '<leader>rf', cmd_window.run_python, b_local)
