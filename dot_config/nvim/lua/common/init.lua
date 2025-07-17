local M = {}

-- Copy relative path of current file to system clipboard
function M.copy_pwd()
  local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  vim.fn.setreg("+", path)
end

function M.copy_abs_path()
  local path = vim.fs.abspath(vim.fn.expand("%"))
  vim.fn.setreg("+", path)
end

-- Yank visually selected text, process with jq, copy to clipboard
function M.jq_yank_visual()
  local start_pos = vim.fn.getpos("'<")[2]
  local end_pos = vim.fn.getpos("'>")[2]
  local lines = vim.fn.getline(start_pos, end_pos)
  local text = table.concat(lines, "\n")
  local result = vim.fn.system("jq -f ~/script.jq", text)
  vim.fn.setreg("+", result)
end

-- Yank visually selected text, process with awk, copy to clipboard
function M.awk_yank_visual()
  local start_pos = vim.fn.getpos("'<")[2]
  local end_pos = vim.fn.getpos("'>")[2]
  local lines = vim.fn.getline(start_pos, end_pos)
  local text = table.concat(lines, "\n")
  local result = vim.fn.system("awk -f ~/script.awk", text)
  vim.fn.setreg("+", result)
end

-- Convert CamelCase to snake_case
function M.camel_to_snake(text)
  return text:gsub("(%u)", function(c)
    return "_" .. c:lower()
  end)
end

-- Convert snake_case to CamelCase
function M.snake_to_camel(text)
  local parts = vim.split(text, "_")
  local camel = parts[1]
  for i = 2, #parts do
    camel = camel .. parts[i]:sub(1, 1):upper() .. parts[i]:sub(2)
  end
  return camel
end

-- Replace the word under cursor with target
function M.replace_cursor_word(target)
  vim.fn.setreg("+", target)
  vim.cmd('normal! viwpb')
end

-- Toggle word under cursor between snake_case and CamelCase
function M.toggle_snake_camel()
  local word = vim.fn.expand("<cword>")
  local text = word:gsub("^_+", "")
  local result = text

  if text:find("_") then
    print("snake case found, snake to camel")
    result = M.snake_to_camel(text)
  elseif text:find("%u") then
    print("camel case found, camel to snake")
    result = M.camel_to_snake(text)
  else
    print("return it unchanged")
  end

  M.replace_cursor_word(result)
end

-- Buffer menu popup
local buf_dict = {}

function M.buffer_menu(search_text)
  local buffers = vim.tbl_map(function(buf)
    return {
      bufnr = buf.bufnr,
      text = vim.fn.fnamemodify(buf.name, ":.:~"),
    }
  end, vim.tbl_filter(function(buf)
    return buf.listed == 1
  end, vim.fn.getbufinfo()))

  if search_text and search_text ~= "" then
    buffers = vim.tbl_filter(function(buf)
      return buf.text:match(search_text)
    end, buffers)

    if #buffers == 0 then
      vim.fn.popup_menu("there is no buffer with name matching " .. search_text, {
        time = 3000,
        cursorline = 0,
        highlight = "WarningMsg"
      })
      return
    end
  end

  buf_dict = buffers
  vim.fn.popup_menu(buffers, {
    callback = "v:lua.require'mymodule'.load_buffer"
  })
end

function M.load_buffer(_, result)
  local buf = buf_dict[result - 1]
  if buf then
    vim.cmd("buffer! " .. buf.bufnr)
  end
end

-- Search across files using grep and present in popup
local search_info_list = {}

function M.search_across_files(search_text)
  local grep_output = vim.fn.system("grep -Irn " .. vim.fn.shellescape(search_text))
  search_info_list = {}

  for _, line in ipairs(vim.split(grep_output, "\n")) do
    local file, lnum, rest = line:match("([^:]+):(%d+):(.*)")
    if file and lnum then
      table.insert(search_info_list, {
        cmd = "edit +" .. lnum .. " " .. file,
        text = line,
      })
    end
  end

  vim.fn.popup_menu(search_info_list, {
    callback = "v:lua.require'mymodule'.go_selected_file",
    scrollbar = 1,
    maxheight = 20,
  })
end

function M.go_selected_file(_, result)
  local entry = search_info_list[result - 1]
  if entry then
    vim.cmd(entry.cmd)
    vim.cmd("normal! zz")
  end
end

-- Key handler for scrolling popup
function M.popup_filter(winid, key)
  local map = {
    j = "<C-e>",
    k = "<C-y>",
    ["<C-d>"] = "<C-d>",
    ["<C-u>"] = "<C-u>",
    ["<C-f>"] = "<C-f>",
    ["<C-b>"] = "<C-b>",
    G = "G",
    g = "gg"
  }

  if map[key] then
    vim.fn.win_execute(winid, "normal! " .. map[key])
    return true
  elseif key == "q" then
    vim.fn.popup_close(winid)
    return true
  end

  return false
end

function M.floating_window(lines)
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

function M.add_floating_window_callback(win, buf, callback)
    vim.keymap.set('n', '<CR>', function()
        callback()
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf })
end

function M.print_item(win, buf)
  local item = vim.api.nvim_get_current_line()
  print("item: " .. item)
end

function M.concat(tbl1, tbl2)
  return vim.tbl_extend("force", tbl1, tbl2)
end

return M
