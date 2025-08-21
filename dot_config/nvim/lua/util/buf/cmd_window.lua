local buf_util = require('util.buf')

local M = {}

function M.command_window(cmd, lseek)
  if cmd == nil or cmd == '' then return end
  lseek = lseek or false
  local cmd_result = vim.fn.execute(cmd)
  local lines = vim.split(cmd_result, "\n", { trimempty = true })
  local win, buf = buf_util.floating_window(lines)
  if lseek then
    vim.cmd.normal('G')
  end
end

function M.system_window(cmd, lseek)
  if cmd == nil or cmd == '' then return end
  lseek = lseek or false
  local cmd_result = vim.fn.execute(cmd)
  local lines = vim.split(cmd_result, "\n", { trimempty = true })
  local win, buf = buf_util.floating_window({unpack(lines, 3)})
end

function M.message_window()
  M.command_window('message', true)
end

function M.map_window()
  M.command_window('map', true)
end

function M.autocmd_window()
  M.command_window('autocmd', true)
end

function M.highlight_window()
  M.command_window('highlight', false)
end

function M.awk_window()
  M.system_window('! awk -f ~/script.awk ~/temp.txt', false)
end

function M.jq_window()
  M.system_window('! jq -r -f ~/script.jq ~/temp.json', false)
end

function M.curl_window()
  M.system_window('! curl --config ~/script.curl', false)
end

function M.gvpr_window()
  M.system_window('! gvpr -f ~/script.gvpr ~/temp.dot', false)
end

function M.run_lua()
  M.command_window('source %', false)
end

function M.run_vim()
  M.command_window('source %', false)
end

function M.run_awk()
  M.system_window('! awk -f %', false)
end

function M.run_python()
  M.system_window('! python3 %', false)
end

function M.run_node()
  M.system_window('! node %', false)
end

function M.run_bash()
  M.system_window('! bash %', false)
end

return M
