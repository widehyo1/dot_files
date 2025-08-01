local M = {}

function M.backtick()
  vim.cmd.normal('gvd')
  vim.cmd.normal('i`')
  vim.cmd.normal('p')
  vim.cmd.normal('a`')
end

function M.quote()
  vim.cmd.normal("gvd")
  vim.cmd.normal("i'")
  vim.cmd.normal("p")
  vim.cmd.normal("a'")
end

function M.double_quote()
  vim.cmd.normal('gvd')
  vim.cmd.normal('i"')
  vim.cmd.normal('p')
  vim.cmd.normal('a"')
end

return M
