setlocal tabstop=2
setlocal shiftwidth=2
setlocal expandtab

iabbrev <buffer> \while; while condition<CR>statements<CR>endwhile
iabbrev <buffer> \for; for varname in listexpression<CR>commands<CR>endfor
iabbrev <buffer> \function; function! Funcname()<CR>" content<CR><C-U>endfunciton

vnoremap <buffer> gcc :s/^/" /<CR>

nnoremap <buffer> <leader>rr :!source %<CR>
