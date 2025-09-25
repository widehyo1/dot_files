function! SyncTerminalBuffer()
  for listed_buffer in filter(getbufinfo(), 'v:val.listed')
    let bufnr = listed_buffer.bufnr
    let buftype = getbufvar(bufnr, '&buftype')
    let buftype = (buftype == '' ? 'normal' : buftype)
    if buftype == 'terminal'
      let term_winid = getbufvar(bufnr, 'winid')
      if win_id2win(term_winid) != 0
        " buffer terminal is opened
        call win_gotoid(term_winid)
      endif
      execute 'buffer! ' .. bufnr
      let pwd = getcwd()
      call feedkeys("i\<C-u>cd " .. pwd .. "\<CR>")
      break
    endif
  endfor
endfunction

call SyncTerminalBuffer()
