local common = require('common')
local b_local = { buffer = 0 }

local bufnr = vim.api.nvim_get_current_buf()

vim.api.nvim_create_autocmd("User", {
    pattern = "RestResponsePre",
    callback = function()
        local res = _G.rest_response
        if res and res.body then
            -- UTF-8로 디코딩
            local decoded = vim.json.decode(res.body)
            -- JSON 포맷팅을 위해 임시 버퍼 사용
            local temp_bufnr = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(temp_bufnr, 0, -1, false, vim.split(res.body, '\n'))
            vim.api.nvim_buf_call(temp_bufnr, function()
                vim.cmd('silent! %!jq "."')
            end)
            res.body = table.concat(vim.api.nvim_buf_get_lines(temp_bufnr, 0, -1, false), '\n')
            vim.api.nvim_buf_delete(temp_bufnr, { force = true })
        end
    end,
})

vim.keymap.set('n', '<leader>run', ':Rest run<CR>', b_local)
