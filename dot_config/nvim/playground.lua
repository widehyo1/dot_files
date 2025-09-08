-- terminal_toggle.lua
local M = {}

-- 저장된 윈도우 상태 (layout)
local saved_winview = nil

-- 현재 윈도우 상태 저장
local function save_window_layout()
  saved_winview = vim.fn.winlayout()
end

-- 저장된 윈도우 상태 복원
local function restore_window_layout()
  if saved_winview then
    vim.cmd("only") -- 기존 창 닫기
    vim.fn.winrestview({}) -- 뷰포트 초기화
    vim.fn.winlayout(saved_winview)
    saved_winview = nil
  else
    print("⚠ 저장된 윈도우 상태가 없습니다.")
  end
end

-- terminal buffer 찾기
local function get_terminal_bufnr()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      if vim.api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
        return bufnr
      end
    end
  end
  return nil
end

-- terminal buffer 열기
function M.open_terminal_only()
  save_window_layout()

  local term_buf = get_terminal_bufnr()
  if term_buf then
    -- 이미 terminal buffer가 있다면 해당 버퍼 열기
    vim.cmd("buffer " .. term_buf)
  else
    -- 없다면 새 terminal 생성
    vim.cmd("terminal")
  end

  -- terminal buffer만 남기고 나머지 닫기
  vim.cmd("only")
end

-- 이전 상태 복원
function M.restore_layout()
  restore_window_layout()
end

return M


local term_toggle = require("terminal_toggle")

-- <leader>tt : 터미널만 띄우기
vim.keymap.set("n", "<leader>tt", term_toggle.open_terminal_only)

-- <leader>tr : 이전 레이아웃 복원
vim.keymap.set("n", "<leader>tr", term_toggle.restore_layout)



-- ~/.config/nvim/init.lua 또는 적절한 설정 파일에 추가

-- 터미널 섹션 text object
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function(args)
    local buf = args.buf
    
    -- 섹션 선택 키맵
    vim.keymap.set({'x', 'o'}, 'is', function()
      -- 현재 섹션 내부 선택 (inner section)
      vim.cmd('normal! ][V[[')
    end, { buffer = buf, desc = 'Select inner terminal section' })
    
    vim.keymap.set({'x', 'o'}, 'as', function()
      -- 섹션 전체 선택 (around section) - 프롬프트 포함
      vim.cmd('normal! ]]V[[')
    end, { buffer = buf, desc = 'Select around terminal section' })
    
    -- 섹션 복사/삭제를 위한 추가 키맵
    vim.keymap.set('n', 'yis', function()
      vim.cmd('normal! ][V[[y')
    end, { buffer = buf, desc = 'Yank inner section' })
    
    vim.keymap.set('n', 'yas', function()
      vim.cmd('normal! ]]V[[y')
    end, { buffer = buf, desc = 'Yank around section' })
    
    vim.keymap.set('n', 'dis', function()
      vim.cmd('normal! ][V[[d')
    end, { buffer = buf, desc = 'Delete inner section' })
    
    vim.keymap.set('n', 'das', function()
      vim.cmd('normal! ]]V[[d')
    end, { buffer = buf, desc = 'Delete around section' })
  end,
})
