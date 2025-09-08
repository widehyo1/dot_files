local common = require('common')

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function(args)
    local buf = args.buf
    vim.api.nvim_buf_set_keymap(buf, 'n', '<C-D>', '<Nop>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 't', '<C-Q>', '<C-\\><C-n>', { noremap = true, silent = true })
    vim.cmd.startinsert()
  end,
})
require('autocmd.custom')
