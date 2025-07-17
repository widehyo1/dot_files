local harpoon = require("harpoon")
local common = require("common")
local nvim_tree_util = require("plugin_util.nvim-tree")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- 디렉토리용 별도 리스트 생성
local dir_list = harpoon:list("directory")

-- 디렉토리 추가
vim.keymap.set("n", "<leader>hd", function()
  dir_list:add({ value = nvim_tree_util.get_directory_path() })
  -- local dir = vim.fn.expand("%:h")
  -- local dir = vim.fn.input("Directory to add: ", nvim_tree_util.get_directory_path())
  -- if vim.fn.isdirectory(dir) == 1 then
  --   dir_list:add({ value = dir })
  --   print("Added: " .. dir)
  -- else
  --   print("Invalid directory")
  -- end
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

  local win, buf = common.floating_window(lines)
  common.add_floating_window_callback(win, buf, function()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local dir = entries[line] and entries[line].value
    if dir then
      vim.cmd("NvimTreeClose")
      vim.cmd("NvimTreeOpen " .. dir)
    end
  end)
end)
