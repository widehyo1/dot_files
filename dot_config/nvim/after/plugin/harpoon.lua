local harpoon = require("harpoon")
local function get_absolute_path()
  local api = require("nvim-tree.api")
  local node = api.tree.get_node_under_cursor()
  return node.absolute_path
end

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- 디렉토리용 별도 리스트 생성
local dir_list = harpoon:list("directory")

-- 디렉토리 추가
vim.keymap.set("n", "<leader>hd", function()
  -- local dir = vim.fn.expand("%:h")
  local dir = vim.fn.input("Directory to add: ", get_absolute_path())
  if vim.fn.isdirectory(dir) == 1 then
    dir_list:add({ value = dir })
    print("Added: " .. dir)
  else
    print("Invalid directory")
  end
end)

-- 디렉토리 북마크 UI
vim.keymap.set("n", "<leader><C-e>", function()
  local entries = dir_list.items
  if #entries == 0 then
    print("No bookmarked directories")
    return
  end

  -- 디렉토리 목록 만들기
  local lines = {}
  for i, item in ipairs(entries) do
    lines[i] = i .. ". " .. item.value
  end

  -- 임시 버퍼 생성
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- 윈도우 사이즈/위치
  local width = 60
  local height = math.min(#lines, 10)
  local row = math.floor((vim.o.lines - height) / 2 - 1)
  local col = math.floor((vim.o.columns - width) / 2)

  -- 윈도우 생성
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  -- 하이라이트 이동 가능하게
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.cmd("setlocal cursorline")

  -- Enter 키 처리
  vim.keymap.set("n", "<CR>", function()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local dir = entries[line] and entries[line].value
    if dir then
      vim.api.nvim_win_close(win, true)
      vim.cmd("NvimTreeClose")
      vim.cmd("NvimTreeOpen " .. dir)
    end
  end, { buffer = buf })
end)
