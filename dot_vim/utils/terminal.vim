function! PrintOpenTerminalMode()
  let terminal_modes = [':sh', ':terminal (cd pwd)', ':terminal', ':terminal (vs)']
  let mode_repr_list = []
  for idx in range(len(terminal_modes))
    let t_mode = terminal_modes[idx]
    if g:open_terminal_mode ==# idx
      let t_mode = '< ' .. t_mode .. ' >'
    endif
    call add(mode_repr_list, t_mode)
  endfor
  echomsg join(mode_repr_list, ' | ')
endfunction

function! ToggleOpenTerminalMode()
  let g:open_terminal_mode = (g:open_terminal_mode + 1) % 4
  call PrintOpenTerminalMode()
endfunction

function! SelectOpenTerminalMode(mode)
  let g:open_terminal_mode = a:mode
  call PrintOpenTerminalMode()
endfunction

function! OpenTerminal()
  call PrintOpenTerminalMode()
  if g:open_terminal_mode == 0
    execute ':sh'
    return
  endif

  if g:open_terminal_mode > 0
    for listed_buffer in filter(getbufinfo(), 'v:val.listed')
      let bufnr = listed_buffer.bufnr
      let buftype = getbufvar(bufnr, '&buftype')
      let buftype = (buftype == '' ? 'normal' : buftype)
      if buftype == 'terminal'
        let term_winid = getbufvar(bufnr, 'winid')
        if win_id2win(term_winid) != 0
          " terminal buffer window is opened
          " move cursor to the window
          call win_gotoid(term_winid)
        endif

        if g:open_terminal_mode == 3 && len(getwininfo()) == 1
          execute 'vsplit'
        endif
        execute 'buffer! ' .. bufnr
        if g:open_terminal_mode == 1
          let pwd = getcwd()
          " sync vim pwd
          call feedkeys("i\<C-u>cd " .. pwd .. "\<CR>")
        endif
        if g:open_terminal_mode == 3 && mode() == 'n'
          call feedkeys("i\<C-u>")
        endif
        return
      endif
    endfor

    if g:open_terminal_mode == 3
      execute 'vsplit'
    endif
    execute 'terminal! ++curwin'
    let term_bufnr = bufnr()
    call setbufvar(term_bufnr, 'winid', bufwinid(term_bufnr)) " save window id
  endif

endfunction

function! Tapi_SyncTerminalPwd(bufnum, arglist)
  execute 'cd ' .. a:arglist
endfunction

function! Tapi_SetOsc7_Dir(bufnum, arglist)
  call setbufvar(a:bufnum, 'osc7_dir', a:arglist)
endfunction

