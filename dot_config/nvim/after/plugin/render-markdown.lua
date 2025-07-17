vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(args)
    vim.treesitter.start(args.buf)
  end,
})
