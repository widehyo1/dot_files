function floating_window(lines)
    local max_line_width = 0
    for _, line in ipairs(lines) do
        max_line_width = math.max(max_line_width, vim.fn.strwidth(line))
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local width = math.max(max_line_width + 2, 80)
    local height = math.max(#lines, 20)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = 'minimal',
        border = 'rounded',
    })

    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.cmd("setlocal cursorline")

    return win, buf
end

function add_floating_window_callback(win, buf, callback)
    vim.keymap.set('n', '<CR>', function()
        callback()
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf })
end

function print_item(win, buf)
  local item = vim.api.nvim_get_current_line()
  print("item: " .. item)
end

-- local lines = {
--     "Hello, world!",
--     "This is a test",
--     "This is a test2",
-- }
--
-- local win, buf = floating_window(lines)
-- add_floating_window_callback(win, buf, print_item)
