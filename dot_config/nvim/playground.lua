-- ANSI escape sequence가 포함된 파일 읽기
local function read_file_lines(path)
  local lines = {}
  local f = io.open(path, "r")
  if not f then
    print("파일을 열 수 없습니다: " .. path)
    return lines
  end
  for line in f:lines() do
    table.insert(lines, line)
  end
  f:close()
  return lines
end

-- 버퍼에 추가
local path = "/mnt/c/Users/widehyo/Desktop/work2/2025/09/17/ls.console"  -- 원하는 로그 파일 경로
local log_lines = read_file_lines(path)

if #log_lines > 0 then
  local lastline = vim.api.nvim_buf_line_count(0)
  local baleia = require('baleia').setup {}
  baleia.buf_set_lines(0, lastline, lastline, true, log_lines)
end
