local buf_util = require('util.buf')

local M = {}

function M.command_window(cmd, from_start)
  if cmd == nil or cmd == '' then return end
  from_start = from_start or true
  local cmd_result = vim.fn.execute(cmd)
  local lines = vim.split(cmd_result, "\n", { trimempty = true })
  local win, buf = buf_util.floating_window(lines)
  if from_start then
    vim.cmd.normal('G')
  end
end

function M.system_window(cmd, from_start)
  if cmd == nil or cmd == '' then return end
  from_start = from_start or true
  local cmd_result = vim.fn.system(cmd)
  local lines = vim.split(cmd_result, "\n", { trimempty = true })
  local win, buf = buf_util.floating_window(lines)
end

function M.message_window()
  M.command_window('message', false)
end

function M.map_window()
  M.command_window('map', false)
end

function M.autocmd_window()
  M.command_window('autocmd', false)
end

function M.highlight_window()
  M.command_window('highlight', true)
end

function M.awk_window()
  M.system_window('awk -f ~/script.awk ~/temp.txt', true)
end

function M.jq_window()
  M.system_window('jq -r -f ~/script.jq ~/temp.json', false)
end

function M.curl_window()
  M.system_window('curl --config ~/script.curl', true)
end

function M.gvpr_window()
  M.system_window('gvpr -f ~/script.gvpr ~/temp.dot', true)
end

function M.httpyac_window()
  M.system_window('cd ~ && httpyac ~/script.http --all', true)
end

function M.run_lua()
  M.command_window('source %', true)
end

function M.run_vim()
  M.command_window('source %', true)
end

function M.run_awk()
  M.system_window('awk -f %', true)
end

function M.run_python()
  M.system_window('python3 %', true)
end

function M.run_node()
  M.system_window('node %', true)
end

function M.run_bash()
  M.system_window('bash %', true)
end

return M
