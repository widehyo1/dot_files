local M = {}

local buf_util = require('util.buf')

local config = {
  filetype = "floating_window",
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

  local fw_group = vim.api.nvim_create_augroup("FloatingWinFocus", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = config.filetype,
    group = fw_group,
    callback = function(args)
      local buf = args.buf
      local win = vim.fn.bufwinid(buf)
      if win == -1 then return end

      -- 윈도우 들어오면 진하게
      vim.api.nvim_create_autocmd("WinEnter", {
        buffer = buf,
        callback = function(ev)
          M.focus_window(win)
        end,
      })

      -- 나가면 다시 흐리게
      vim.api.nvim_create_autocmd("WinLeave", {
        buffer = buf,
        callback = function(ev)
          M.fade_window(win)
        end,
      })
    end,
  })
end

function M.focus_window(win)
  vim.api.nvim_win_set_option(win, "winblend", config.winblend_active)
  vim.api.nvim_win_set_option(win, "winhighlight", "")
end

function M.fade_window(win)
  vim.api.nvim_win_set_option(win, "winblend", config.winblend_inactive)
  vim.api.nvim_win_set_option(win, "winhighlight", "Normal:FadedNormal")
end

M.setup()

local buf_opt = {
  filetype = 'floating_window',
}


local win, buf = buf_util.floating_window(lines, nil, nil, buf_opt)
