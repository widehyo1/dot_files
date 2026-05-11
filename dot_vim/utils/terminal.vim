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

function! IsListedBuffer(idx, val)
  return a:val.listed
endfunction

function! IsTerminalBuffer(idx, val)
  return getbufvar(a:val.bufnr, '&buftype') ==# 'terminal'
endfunction

function! GetListedTerminalBuffers()
    return getbufinfo()
          \ ->filter(function('IsListedBuffer'))
          \ ->filter(function('IsTerminalBuffer'))
endfunction


function! OpenTerminalBuffer(bufnr)
  if g:open_terminal_mode == 3 && len(getwininfo()) == 1
    execute 'vsplit'
  endif
  execute 'buffer! ' .. a:bufnr
  if g:open_terminal_mode == 1
    let pwd = getcwd()
    " sync vim pwd
    call feedkeys("i\<C-u>cd " .. pwd .. "\<CR>")
  endif
  if g:open_terminal_mode == 3 && mode() == 'n'
    call feedkeys("i\<C-u>")
  endif
endfunction


function! ConvertTerminalBufferInfo(idx, val) abort
  let buf = a:val
  return { 'text': buf.name, 'cmd': 'call OpenTerminalBuffer(' .. a:val.bufnr .. ')' }
endfunction

function! GoSelectedTerminalBuffer(id, result)
  if a:result <= 0
    return
  endif
  let target_dict = s:terminal_buffer_info_list[a:result-1]
  execute target_dict['cmd']
endfunction

function! OpenTerminal()
  call PrintOpenTerminalMode()
  if g:open_terminal_mode == 0
    execute ':sh'
    return
  endif

  if g:open_terminal_mode > 0

    let listed_terminal_buffers = GetListedTerminalBuffers()
    let listed_terminal_buffers_count = len(listed_terminal_buffers)

    if listed_terminal_buffers_count == 0

      if g:open_terminal_mode == 3
        execute 'vsplit'
      endif

      execute 'terminal! ++curwin'
      let term_bufnr = bufnr()
      call setbufvar(term_bufnr, 'winid', bufwinid(term_bufnr)) " save window id

      return

    elseif listed_terminal_buffers_count == 1
      let term_bufnr = listed_terminal_buffers[0].bufnr
      call OpenTerminalBuffer(term_bufnr)

      return

    else
      let s:terminal_buffer_info_list = copy(listed_terminal_buffers)
            \ ->map(function('ConvertTerminalBufferInfo'))

      let popup_config = #{
            \ callback: 'GoSelectedTerminalBuffer',
            \ filter: 'PopupFilter',
            \ scrollbar: 1,
            \ maxheight: 20
            \ }
      call popup_menu(s:terminal_buffer_info_list, popup_config)

    endif

  endif

endfunction

function! Tapi_SyncTerminalPwd(bufnum, arglist)
  execute 'cd ' .. a:arglist
endfunction

function! Tapi_SetOsc7_Dir(bufnum, arglist)
  call setbufvar(a:bufnum, 'osc7_dir', a:arglist)
endfunction

