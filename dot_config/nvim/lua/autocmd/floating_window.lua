local fs_util = require('util.fs')
local buf_util = require('util.buf')

local M = {}

local config = {
  winblend_active = 0,
  winblend_inactive = 80,
  faded_hl = {
    fg = "#222222",
    bg = "#1e1e1e"
  }
}

function M.setup(user_config)

  config = vim.tbl_deep_extend("force", config, user_config or {})

  -- 하이라이트 설정
  vim.api.nvim_set_hl(0, "FadedNormal", config.faded_hl)

  local user_group = vim.api.nvim_create_augroup("UserCustom", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "floating_window",
    group = user_group,
    callback = function(args)
      local buf = args.buf
      local win = vim.fn.bufwinid(buf)
      if win == -1 then return end

      local load_config = {
        pre_callback = function()
          print(string.format("pre_callback returns %s", vim.fn.getline(".")))
          return vim.fn.getline(".")
        end,
        post_callback = function(line)
          local type, cmd = fs_util.make_load_command(line)
          vim.cmd(cmd)
        end,
        key = "<leader>gf"
      }

      buf_util.add_floating_window_callback(win, buf, load_config)

      -- 윈도우 들어오면 진하게
      vim.api.nvim_create_autocmd("WinEnter", {
        buffer = buf,
        callback = function(ev)
          local new_buf = ev.buf
          local new_win = vim.fn.bufwinid(new_buf)
          vim.o.hlsearch = false
          M.focus_window(win)
        end,
      })

      -- 나가면 다시 흐리게
      vim.api.nvim_create_autocmd("WinLeave", {
        buffer = buf,
        callback = function(ev)
          local new_buf = ev.buf
          local new_win = vim.fn.bufwinid(new_buf)
          vim.o.hlsearch = true
          M.fade_window(win)
        end,
      })
    end,
  })
end

function M.focus_window(win)
  win = win or 0
  vim.api.nvim_win_set_option(win, "winblend", config.winblend_active)
  vim.api.nvim_win_set_option(win, "winhighlight", "")
end

function M.fade_window(win)
  win = win or 0
  vim.api.nvim_win_set_option(win, "winblend", config.winblend_inactive)
  vim.api.nvim_win_set_option(win, "winhighlight", "Normal:FadedNormal")
end

function M.toggle_focus()
  if vim.o.winblend == 0 then
    M.fade_window()
  else
    M.focus_window()
  end
end

return M
