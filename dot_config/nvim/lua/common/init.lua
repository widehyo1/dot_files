local lua_util = require('util.lua')
local buf_util = require('util.buf')
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

  local select_buffer = function ()
    return buffers[vim.fn.line(".")]
  end

  local load_buffer = function (item)
    vim.cmd("buffer! " .. item.bufnr)
  end

  local win, buf = buf_util.floating_window(buffers, 'path')
  buf_util.add_floating_window_callback(win, buf, select_buffer, load_buffer)

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
  local select = function()
    return vim.fn.line(".")
  end
  local execute = function(item)
    vim.cmd(lines[item])
  end

  local win, buf = buf_util.floating_window(lines)
  buf_util.add_floating_window_callback(win, buf, select, execute)
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

return M
