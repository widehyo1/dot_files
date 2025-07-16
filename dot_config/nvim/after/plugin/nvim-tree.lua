local silent_noremap = { noremap = true, silent = true }
-- nvimtree
vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeToggle<CR>', silent_noremap)
vim.keymap.set('n', '<leader>.', function()
    vim.cmd("NvimTreeOpen " .. vim.fn.expand("%:h"))
end)
