local lua_util = require('util.lua')
local buf_util = require('util.buf')
local fs_util = require('util.fs')
local chain = require('util.chain')

local M = {}

-- Buffer menu popup
function M.buffer_menu(search_text)
  local buf_listed = function(buf) return buf.listed == 1 end
  local bufnr_relpath = function(buf)
    return {
      bufnr = buf.bufnr,
      path = vim.fn.fnamemodify(buf.name, ":.:~")
    }
  end
  local search_match = function(buf) return buf.path:match(search_text) end
  local buffers = chain.from(vim.fn.getbufinfo())
    :filter(buf_listed)
    :apply(bufnr_relpath)
    :get()

  if search_text and search_text ~= "" then
    buffers = chain.from(buffers)
      :filter(search_match)
      :get()
    if #buffers == 0 then
      local empty_msg = "there is no buffer with name matching <" .. search_text .. ">"
      local win, buf = buf_util.floating_window({empty_msg})
      buf_util.add_floating_window_callback(win, buf)
      return
    end
  end

  local callback_opt = {
    pre_callback = function()
      return buffers[vim.fn.line(".")]
    end,
    post_callback = function(item)
      vim.cmd("buffer! " .. item.bufnr)
    end
  }

  local win, buf = buf_util.floating_window(buffers, 'path')
  buf_util.add_floating_window_callback(win, buf, callback_opt)

end

function M.search_across_files(search_text)
  -- ripgrep command
  local cmd = {
    'rg',
    '--no-heading',
    '--with-filename',
    '--line-number',
    '--fixed-strings'
  }

  if vim.fn.empty(search_text) == 1 then
    search_text = vim.fn.getreg('/')
    if search_text:find('\\<') and search_text:find('\\>') then
      search_text = search_text
        :gsub('\\<', '')
        :gsub('\\>', '')
      table.insert(cmd, '--word-regexp')
    end
  end

  if search_text == nil or search_text == '' then
    return
  end

  table.insert(cmd, search_text)
  local items = vim.fn.systemlist(cmd)

  if vim.v.shell_error ~= 0 or #items == 0 then
    local empty_msg = "No matches found content matching <" .. search_text .. ">"
    local win, buf = buf_util.floating_window({empty_msg})
    buf_util.add_floating_window_callback(win, buf)
    return
  end

  local callback_opt = {
    pre_callback = function()
      return items[vim.fn.line(".")]
    end,
    post_callback = function(item)
     local filename, linenumber, text = item:match('^([^:]+):(%d+):(.*)$')
      vim.cmd(string.format(
        'edit +%s %s',
        linenumber,
        vim.fn.fnameescape(filename)
      ))
    end
  }

  local win, buf = buf_util.floating_window(items)
  buf_util.add_floating_window_callback(win, buf, callback_opt)
end


function M.open_jumplist_popup()
  local lines = vim.split(vim.fn.execute('jumps', 'silent'), '\n')

  local jump_items = {}

  -- Skip last empty line
  for i = 1, #lines - 1 do
    local line = lines[i]

    -- jumps output: id line col file...
    local parts = vim.split(line, '%s+')
    local linenr = parts[3]
    local file_text = table.concat(parts, ' ', 5)

    if file_text ~= '' and vim.fn.findfile(file_text) ~= '' then
      table.insert(jump_items, {
        text = line,
        cmd = string.format('edit +%s %s', linenr, vim.fn.fnameescape(file_text)),
      })
    end
  end

  if #jump_items == 0 then
    return
  end

  local callback_opt = {
    pre_callback = function()
      return jump_items[vim.fn.line(".")]
    end,
    post_callback = function(item)
      vim.cmd(item.cmd)
    end
  }

  local win, buf = buf_util.floating_window(jump_items, 'text')
  buf_util.add_floating_window_callback(win, buf, callback_opt)
end


function M.open_changelist_popup()
  local lines = vim.split(vim.fn.execute('changes', 'silent'), '\n')

  local change_items = {}

  for i = 1, #lines - 1 do
    local line = lines[i]

    -- changes output: id line col ...
    local parts = vim.split(line, '%s+')
    local linenr = parts[3]

    if linenr then
      table.insert(change_items, {
        text = line,
        cmd = string.format('normal! %sG', linenr),
      })
    end
  end

  if #change_items == 0 then
    return
  end

  local callback_opt = {
    pre_callback = function()
      return change_items[vim.fn.line(".")]
    end,
    post_callback = function(item)
      vim.cmd(item.cmd)
    end
  }

  local win, buf = buf_util.floating_window(change_items, 'text')
  buf_util.add_floating_window_callback(win, buf, callback_opt)

end

function M.command_menu(hist_size)
  if hist_size then
    hist_size = tonumber(hist_size)
  else
    hist_size = 20
  end

  local histories = vim.fn.execute('history cmd -' .. hist_size .. ',')
  local lines = vim.split(histories, "\n", { trimempty = true })
  -- skip first row
  lines = vim.list_slice(lines, 2)
  -- extract  part
  local extract_ = function(line)
    for _, cmd in line:sub(2):gmatch('%s+(%d*)%s+(.+)') do
      return cmd
    end
  end
  lines = chain.from(lines)
    :apply(extract_)
    :get()

  local callback_opt = {
    pre_callback = function()
      return vim.fn.line(".")
    end,
    post_callback = function(item)
      vim.cmd(lines[item])
    end
  }

  local win, buf = buf_util.floating_window(lines)
  buf_util.add_floating_window_callback(win, buf, callback_opt)
end

function M.add_snippet(trigger, body, opts)
  vim.keymap.set("ia", trigger, function()
    -- If abbrev is expanded with keys like "(", ")", "<cr>", "<space>",
    -- don't expand the snippet. Only accept "<c-]>" as a trigger key.
    local c = vim.fn.nr2char(vim.fn.getchar(0))
    if c ~= "" then
      vim.api.nvim_feedkeys(trigger .. c, "i", true)
      return
    end
    vim.snippet.expand(body)
  end, opts)
end

function M.get_buffer_file()
  return vim.fn.fnamemodify(vim.fn.expand('%'), ":t")
end

function M.get_buffer_dir()
  return vim.fn.fnamemodify(vim.fn.expand('%'), ":p:h")
end

function M.get_pwd()
  return lua_util.strip(vim.fn.execute('pwd'))
end

function M.copy_to_pwd(filename)
  local target_path = ""
  if filename == nil or filename == "" then
    -- default filename is the current buffer file name
    filename = M.get_buffer_file()
    assert(buffer_filename ~= "", "file name is requried when current buffer has noname")
  end

  target_path = M.get_pwd() .. "/" .. filename
  local cmd = "write " .. target_path
  vim.fn.execute(cmd)
end

function M.cd_current_line()
  local line = lua_util.strip(vim.fn.getline('.'))
  local mode = vim.api.nvim_get_mode().mode
  local buftype = vim.bo.buftype

  if mode == "nt" then
    -- assume PS1 ='\[\033[01;34m\]\w\[\033[00m\] $ '
    if vim.endswith(line, " $") then
      line = string.sub(line, 1, -3)
    end
  end

  local target_dir = fs_util.get_directory(line)
  local cmd = 'cd ' .. target_dir
  vim.fn.execute(cmd)
end

function M.get_selection()
  return vim.fn.getline("'<", ">'")
end

function M.make_termpath(path)
  return 'edit term://' .. path .. '//bash'
end

function M.floating_terminal()
  local win, buf = buf_util.floating_window()
  vim.fn.execute('terminal')
  vim.bo.filetype = 'floating_window'
  vim.keymap.set('n', '<C-D>', function()
    -- vim.fn.execute('bp|bd! #')
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf })
end

function _G.tabline_buffers()
  local cur_buf = vim.api.nvim_get_current_buf()

  local buf_listed = function(buf) return buf.listed == 1 end
  local get_bufname = function(buf)
    local name = ''
    if buf.name == '' then 
      name = '[No Name]'
    else
      name = vim.fn.fnamemodify(buf.name, ":t")
    end
    if buf.changed == 1 then
      name = name .. ' +'
    end
    if buf.bufnr == cur_buf then
      name = '< ' .. name .. ' >'
    end
    return name
  end

  local joiner = function(acc, cur)
    return acc .. ' | ' .. cur
  end

  local buf_name_str = chain.from(vim.fn.getbufinfo())
    :filter(buf_listed)
    :apply(get_bufname)
    :reduce(joiner)

  return buf_name_str
end

function M.select_open_terminal_mode(mode)
  vim.g.open_terminal_mode = mode
  M.print_open_terminal_mode()
end

function M.toggle_open_terminal_mode()
  vim.g.open_terminal_mode = (vim.g.open_terminal_mode + 1) % 3
  M.print_open_terminal_mode()
end

function M.print_open_terminal_mode()
  print(vim.g.open_terminal_mode)
  local terminal_modes = {':terminal (cd pwd)', ':terminal', ':terminal (vs)'}
  local joiner = function(acc, cur)
    return acc .. ' | ' .. cur
  end
  for idx, modename in ipairs(terminal_modes) do
    if (idx - 1) == vim.g.open_terminal_mode then
      terminal_modes[idx] = '< ' .. modename .. ' >'
    end
  end
  print(chain.from(terminal_modes)
    :reduce(joiner)
  )
end

function M.open_terminal()
  M.print_open_terminal_mode()
  local buffers = vim.api.nvim_list_bufs()
  
  for _, buf in ipairs(buffers) do
    -- 버퍼가 유효하고 터미널 타입인지 확인
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, 'buftype') == 'terminal' then
      local term_winid = vim.fn.getbufvar(buf, 'winid')
      if vim.fn.win_id2win(term_winid) ~= 0 then
        -- terminal buffer window is opened
        -- move cursor to the window
        vim.fn.win_gotoid(term_winid)
      end

      if vim.g.open_terminal_mode == 2 and #vim.fn.getwininfo() == 1 then
        vim.cmd('vsplit')
      end
      vim.cmd('buffer! ' .. buf)

      local job_id = vim.b[buf].terminal_job_id

      if vim.g.open_terminal_mode == 0 then
        if job_id and vim.fn.jobwait({job_id}, 0)[1] == -1 then
          vim.fn.chansend(job_id, '\x15')
          vim.fn.chansend(job_id, 'cd ' .. vim.fn.fnameescape(vim.fn.getcwd()) .. '\n')
        end
      end

      if vim.g.open_terminal_mode == 2 and vim.fn.mode() == 'n' then
        vim.fn.chansend(job_id, '\x15')
      end
      return
    end
  end

  if vim.g.open_terminal_mode == 2 then
    vim.cmd('vsplit')
  end
  
  vim.fn.execute('terminal')
  local term_bufnr = vim.fn.bufnr()
  vim.fn.setbufvar(term_bufnr, 'winid', vim.fn.bufwinid(term_bufnr)) -- save window id
end

function M.sync_terminal_pwd()
  print('vim.b.osc7_dir: ' .. vim.b.osc7_dir)
  if vim.b.osc7_dir and vim.fn.isdirectory(vim.b.osc7_dir) == 1 then
    vim.cmd.cd(vim.b.osc7_dir)
  end
end

return M
