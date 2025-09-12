function! OpenTerminal()
  for listed_buffer in filter(getbufinfo(), 'v:val.listed')
    let bufnr = listed_buffer.bufnr
    let buftype = getbufvar(bufnr, '&buftype')
    let buftype = (buftype == '' ? 'normal' : buftype)
    if buftype == 'terminal'
      execute 'buffer! ' .. bufnr
      return
    endif
  endfor

  execute 'terminal! ++curwin'
endfunction

call OpenTerminal()
