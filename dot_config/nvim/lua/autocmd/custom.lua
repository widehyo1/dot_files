local M = {}

function M.fw_setup(opts)
  require('autocmd.floating_window').setup(opts or {})
end

return M
