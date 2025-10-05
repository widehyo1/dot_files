local common = require('common')

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function(args)
    local buf = args.buf
    vim.keymap.set('n', '<C-D>', '<C-^>', { noremap = true, silent = true, buffer = buf })
    vim.keymap.set('n', '<leader>cd', common.sync_terminal_pwd, { noremap = true, silent = true, buffer = buf })
    vim.keymap.set('t', '<C-Q>', [[<C-\><C-n>]], { noremap = true, silent = true, buffer = buf })

    vim.cmd.startinsert()
  end,
})

-- terminal 버퍼에서 pwd를 이용해 vim의 :pwd 동기화
vim.api.nvim_create_autocmd({ 'TermRequest' }, {
  desc = 'Handles OSC 7 dir change requests',
  callback = function(ev)
    if string.sub(ev.data.sequence, 1, 4) == '\x1b]7;' then
      local dir = string.gsub(ev.data.sequence, '\x1b]7;file://[^/]*', '')
      if vim.fn.isdirectory(dir) == 0 then
        vim.notify('invalid dir: '..dir)
        return
      end
      vim.api.nvim_buf_set_var(ev.buf, 'osc7_dir', dir)
    end
  end
})

require('autocmd.custom')
