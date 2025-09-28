local M = {}

function M.floating_window(lines, field, win_opt, buf_opt)
  lines = lines or {}
  local contents = {}

  win_opt = win_opt or {}
  buf_opt = buf_opt or {}

  for _, line in ipairs(lines) do
    table.insert(contents, line)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, contents)

  local width = vim.fn.float2nr(vim.o.columns * 0.8)
  local height = vim.fn.float2nr(vim.o.lines * 0.8)

  local win = vim.api.nvim_open_win(buf, true, vim.tbl_deep_extend("force", {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = 'rounded',
  }, win_opt))

  -- default window, buffer option
  vim.api.nvim_set_option_value('modifiable', false, {buf=buf})
  vim.api.nvim_set_option_value('cursorline', true, {win=win})

  for key, value in pairs(buf_opt) do
    vim.api.nvim_set_option_value(key, value, {buf=buf})
  end

  return win, buf
end

function M.command_window(cmd, lseek)
  if cmd == nil or cmd == '' then return end
  lseek = lseek or false
  local cmd_result = vim.fn.execute(cmd)
  local lines = vim.split(cmd_result, "\n", { trimempty = true })
  local win, buf = M.floating_window(lines)
  if lseek then
    vim.cmd.normal('G')
  end
end

function M.system_window(cmd, lseek)
  if cmd == nil or cmd == '' then return end
  lseek = lseek or false
  local cmd_result = vim.fn.system(cmd)
  local lines = vim.split(cmd_result, "\n", { trimempty = true })
  local win, buf = M.floating_window(lines)
end

-- M.command_window('map', true)
M.command_window('messages', true)
-- M.system_window('awk -f ~/script.awk ~/temp.txt')
