setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2

nnoremap <buffer> <leader>rr :!node %<CR>

vnoremap <buffer> gcc :s/^/\/\/ /<CR>
