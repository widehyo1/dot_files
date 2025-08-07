local b_local = { buffer = 0 }

local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set('n', '<leader>w', ':write! /home/widehyo/.config/nvim/lua/data/bookmark<CR>', b_local)
