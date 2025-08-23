local win_id = 0  -- Replace with your window ID
local buf_id = vim.api.nvim_win_get_buf(win_id)

print("Buffer ID in this window:", buf_id)
