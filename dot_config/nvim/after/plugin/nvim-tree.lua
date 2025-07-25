local lua_util = require("util.lua")
local util = require("plugin_util.nvim-tree")
local silent_noremap = { noremap = true, silent = true }

-- nvimtree
vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeToggle<CR>', silent_noremap)
vim.keymap.set('n', '<leader>.', function()
  if util.is_visible() then
    vim.cmd(":NvimTreeFindFile")
  else
    vim.cmd(":NvimTreeClose|NvimTreeOpen " .. vim.fn.expand("%:h"))
  end
end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function()
    local buffer_noremap = lua_util.concat(silent_noremap, { buffer = true })
    vim.keymap.set('n', '<leader>cd', util.cd_node, buffer_noremap)
  end
})

