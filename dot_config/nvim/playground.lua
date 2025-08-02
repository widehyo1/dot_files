local M = {}

local MM = {}

function MM.send_esc()
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes('<Esc>', true, false, true),
    'n',
    true
  )
end

function MM.surround_visual(start_char, end_char)
  local start_nomal_cmd = 'a' .. start_char
  local end_nomal_cmd = 'i' .. end_char
  vim.cmd.normal('c')
  vim.cmd.normal(start_nomal_cmd)
  vim.cmd.normal('gp')
  vim.cmd.normal(end_nomal_cmd)
end

function MM.surround_visual_line(start_char, end_char, line_break)
  local start_nomal_cmd = 'a' .. start_char
  local end_nomal_cmd = 'i' .. end_char
  if line_break then
    vim.cmd.normal('c')
    vim.cmd.normal(start_nomal_cmd)
    vim.cmd.normal('gp')
    vim.cmd.normal(end_nomal_cmd)
  else
    local start_pos = vim.fn.getpos("'<")  -- [bufnum, lnum, col, off]
    local end_pos   = vim.fn.getpos("'>")  -- [bufnum, lnum, col, off]
    local start_line_nr = start_pos[2]
    local end_line_nr = end_pos[2]

    vim.fn.setline(start_line_nr, start_char .. vim.fn.getline(start_line_nr))
    vim.fn.setline(end_line_nr, vim.fn.getline(end_line_nr) .. end_char)
    MM.send_esc()
  end
end

function MM.surround_visual_block(start_char, end_char)
  local write_cmd = 'c' .. start_char .. end_char
  vim.cmd.normal(write_cmd)
  vim.cmd.normal('gP')
end


function MM.surround_factory(start_char, end_char, line_break)
  local visual_mode_dict = {
    v = function() MM.surround_visual(start_char, end_char) end,
    V = function() MM.surround_visual_line(start_char, end_char, line_break) end,
    ["\22"] = function() MM.surround_visual_block(start_char, end_char) end
  }
  vim.cmd.normal('gv')
  local visual_mode = vim.fn.visualmode()
  local handler = visual_mode_dict[visual_mode]
  if handler then
    return handler()
  end
end

function M.backtick(line_break)
  MM.surround_factory('`', '`', line_break)
end

function M.quote(line_break)
  MM.surround_factory("'", "'", line_break)
end

function M.double_quote(line_break)
  MM.surround_factory('"', '"', line_break)
end

function M.round_braket(line_break)
  MM.surround_factory('(', ')', line_break)
end

function M.square_braket(line_break)
  MM.surround_factory('[', ']', line_break)
end

function M.angle_braket(line_break)
  MM.surround_factory('<', '>', line_break)
end

function M.curly_braket(line_break)
  MM.surround_factory('{', '}', line_break)
end

M.curly_braket()
