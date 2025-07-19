local lua_util = require('util.lua')
local buf_util = require('util.buf')
local chain = require('util.chain')

local M = {}

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
      buf_util.add_floating_window_callback(win, buf, function() end)
      return
    end
  end

  local print_item = function ()
    local selection = vim.fn.line(".")
    vim.cmd("buffer! " .. buffers[selection].bufnr)
  end

  local win, buf = buf_util.floating_window(buffers, 'path')
  buf_util.add_floating_window_post_callback(win, buf, print_item)

end

local util = M

util.buffer_menu()
-- util.buffer_menu('init')
