function! OpenTerminal()
  let job_option = #{
        \ callback: 'EchoTest'
        \ }
  call job_start('pwd', job_option)
endfunction

function! EchoTest(a, b)
  echomsg a:a .. '|' .. a:b
endfunction

function! Nop(a, b)
  return
endfunction

function! OpenPopup()
  let pop_width = float2nr(&columns * 0.8)
  let pop_height = float2nr(&lines * 0.8)
  let lines = split(execute('message', 'silent'), '\n')
  let popup_config = #{
        \ callback: 'Nop',
        \ scrollbar: 1,
        \ maxheight: pop_height,
        \ minheight: pop_height,
        \ maxwidth: pop_width,
        \ minwidth: pop_width,
        \ filter: 'ScrollPopupFilter',
        \ filtermode: 'n'
        \ }

  let winid = popup_menu(lines, popup_config)
  echomsg winid
  call win_execute(winid, 'normal! G')
  call win_execute(winid, 'normal! \<c-b>')
endfunction

function! ScrollPopupFilter(winid, key) abort
    if a:key ==# "j"
        call win_execute(a:winid, "normal! \<c-e>")
    elseif a:key ==# "k"
        call win_execute(a:winid, "normal! \<c-y>")
    elseif a:key ==# "\<c-d>"
        call win_execute(a:winid, "normal! \<c-d>")
    elseif a:key ==# "\<c-u>"
        call win_execute(a:winid, "normal! \<c-u>")
    elseif a:key ==# "\<c-f>"
        call win_execute(a:winid, "normal! \<c-f>")
    elseif a:key ==# "\<c-b>"
        call win_execute(a:winid, "normal! \<c-b>")
    elseif a:key ==# "G"
        call win_execute(a:winid, "normal! G")
    elseif a:key ==# "g"
        call win_execute(a:winid, "normal! gg")
    elseif a:key ==# "\<space>"
        call win_execute(a:winid, "normal! \<c-f>")
    elseif a:key ==# "u"
        call win_execute(a:winid, "normal! \<c-b>")
    elseif a:key ==# "1"
        call win_execute(a:winid, "normal! 10%")
    elseif a:key ==# "2"
        call win_execute(a:winid, "normal! 20%")
    elseif a:key ==# "3"
        call win_execute(a:winid, "normal! 30%")
    elseif a:key ==# "4"
        call win_execute(a:winid, "normal! 40%")
    elseif a:key ==# "5"
        call win_execute(a:winid, "normal! 50%")
    elseif a:key ==# "6"
        call win_execute(a:winid, "normal! 60%")
    elseif a:key ==# "7"
        call win_execute(a:winid, "normal! 70%")
    elseif a:key ==# "8"
        call win_execute(a:winid, "normal! 80%")
    elseif a:key ==# "9"
        call win_execute(a:winid, "normal! 90%")
    elseif a:key ==# 'q'
        call popup_close(a:winid)
    else
        call popup_close(a:winid)
        return v:false
    endif
    return v:true
endfunction

call OpenPopup()
