vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "/home/widehyo/.config/nvim/lua/data/bookmark",
  callback = function()
    vim.bo.filetype = "bookmark"
  end,
})
