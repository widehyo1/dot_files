local M = {}

function M.floating_window(lines, field, win_opt, buf_opt)
  local max_line_width = 0
  local contents = {}

  -- set content-extracting function
  local get_content = function(line) return line end
  if field and field ~= "" then
    get_content = function(line) return line[field] end
  end

  win_opt = win_opt or {}
  buf_opt = buf_opt or {}

  for _, line in ipairs(lines) do
    local content = get_content(line)
    table.insert(contents, content)
    max_line_width = math.max(max_line_width, vim.fn.strwidth(content))
  end

  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, contents)

  local win = M.display_floating_window(buf, win_opt, buf_opt)

  return win, buf
end

function M.display_floating_window(buf, win_opt, buf_opt)

  local width = vim.fn.float2nr(vim.o.columns * 0.8)
  local height = vim.fn.float2nr(vim.o.lines * 0.8)

  -- default floating window option
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

  return win
end

function M.add_floating_window_callback(win, buf, opt)
  opt = opt or {}
  local pre_callback = opt['pre_callback']
  local post_callback = opt['post_callback']
  local key = opt['key'] or '<CR>'
  local close_window = opt['close_window']

  vim.keymap.set('n', key, function()
    local item = nil
    if pre_callback then
      item = pre_callback()
    end
    if close_window == nil or close_window == true then
      vim.api.nvim_win_close(win, true)
    end
    if post_callback then
      post_callback(item)
    end
  end, { buffer = buf })
end

return M
