function paste_code_block(info_string)
  local code_block_start = "```"
  local code_block_end = "```"
  if info_string then
    code_block_start = code_block_start .. info_string
  end
  local code_block = code_block_start
    .. '\n' .. vim.fn.getreg('0') .. '\n'
    .. code_block_end
  print(code_block)
  local lines = vim.split(code_block, '\n', {plain = true})
  vim.api.nvim_put(lines, 'l', true, true)
end

vim.api.nvim_create_user_command(
  'PasteCodeBlock',
  function(opts)
    local info_string = opts.fargs[1]
    paste_code_block(info_string)
  end,
  {
    nargs = 1,
    desc = "Paste codeblock with infomation string"
  }
)

vim.keymap.set('n', '<leader>p', ':PasteCodeBlock ')

