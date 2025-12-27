function! PopupFilter(winid, key) abort
    if a:key ==# "j"
        call win_execute(a:winid, "normal! j")
    elseif a:key ==# "k"
        call win_execute(a:winid, "normal! k")
    elseif a:key ==# "\<c-d>"
        call win_execute(a:winid, "normal! \<c-d>")
    elseif a:key ==# "\<c-u>"
        call win_execute(a:winid, "normal! \<c-u>")
    elseif a:key ==# "\<c-f>"
        call win_execute(a:winid, "normal! \<c-f>")
    elseif a:key ==# "\<c-b>"
        call win_execute(a:winid, "normal! \<c-b>")
    elseif a:key ==# "\<space>"
        call win_execute(a:winid, "normal! \<c-f>")
    elseif a:key ==# "u"
        call win_execute(a:winid, "normal! \<c-b>")
    elseif a:key ==# "v"
        call win_execute(a:winid, "normal! v")
    elseif a:key ==# "V"
        call win_execute(a:winid, "normal! V")
    elseif a:key ==# "y"
        call win_execute(a:winid, "normal! y")
    elseif a:key ==# "G"
        call win_execute(a:winid, "normal! G")
    elseif a:key ==# "g"
        call win_execute(a:winid, "normal! gg")
    elseif a:key ==# 'q'
        call popup_close(a:winid)
    else
        return v:false
    endif
    return v:true
endfunction

function! OpenExcommandPopup(excommand, lseek = v:false)
  let pop_width = float2nr(&columns * 0.8)
  let pop_height = float2nr(&lines * 0.8)
  let lines = split(execute(a:excommand, 'silent'), '\n')
  let popup_config = #{
        \ scrollbar: 1,
        \ maxheight: pop_height,
        \ minheight: pop_height,
        \ maxwidth: pop_width,
        \ minwidth: pop_width,
        \ filter: 'PopupFilter'
        \ }

  let winid = popup_menu(lines, popup_config)

  if a:lseek
    call win_execute(winid, 'normal! G')
    call win_execute(winid, 'normal! \<c-b>')
  endif
endfunction

function! OpenSystemPopup(command, lseek = v:false)
  let pop_width = float2nr(&columns * 0.8)
  let pop_height = float2nr(&lines * 0.8)

  let lines = split(system(a:command, 'silent'), '\n')
  let popup_config = #{
        \ scrollbar: 1,
        \ maxheight: pop_height,
        \ minheight: pop_height,
        \ maxwidth: pop_width,
        \ minwidth: pop_width,
        \ filter: 'PopupFilter'
        \ }

  let winid = popup_menu(lines, popup_config)

  if a:lseek
    call win_execute(winid, 'normal! G')
    call win_execute(winid, 'normal! \<c-b>')
  endif
endfunction

function! OpenJumplistPopup()
  let pop_width = float2nr(&columns * 0.8)
  let pop_height = float2nr(&lines * 0.8)
  let lines = split(execute('jumps', 'silent'), '\n')
  let s:jump_info_list = []
  for line in lines->slice(0,-1)
    let info_dict = {}
    let [jump_id, linenr, colnr; rest] = split(line)
    let file_text = rest->join(' ')
    if empty(findfile(file_text))
      continue
    endif
    let info_dict['text'] = line
    let info_dict['cmd'] = 'edit +' . linenr . ' ' . file_text
    call add(s:jump_info_list, info_dict)
  endfor
  let popup_config = #{
        \ scrollbar: 1,
        \ maxheight: pop_height,
        \ minheight: pop_height,
        \ maxwidth: pop_width,
        \ minwidth: pop_width,
        \ callback: 'GoJumplist'
        \ }

  let winid = popup_menu(s:jump_info_list, popup_config)

  call win_execute(winid, 'normal! G')
  call win_execute(winid, 'normal! \<c-b>')
endfunction

function! GoJumplist(id, result)
  let target_dict = s:jump_info_list[a:result-1]
  execute target_dict['cmd']
  normal zz
endfunction

function! OpenChangelistPopup()
  let pop_width = float2nr(&columns * 0.8)
  let pop_height = float2nr(&lines * 0.8)
  let lines = split(execute('changes', 'silent'), '\n')
  let s:change_info_list = []
  for line in lines->slice(0,-1)
    let info_dict = {}
    let [change_id, linenr, colnr; rest] = split(line)
    let info_dict['text'] = line
    let info_dict['cmd'] = 'normal ' . linenr . 'G'
    call add(s:change_info_list, info_dict)
  endfor
  let popup_config = #{
        \ scrollbar: 1,
        \ maxheight: pop_height,
        \ minheight: pop_height,
        \ maxwidth: pop_width,
        \ minwidth: pop_width,
        \ callback: 'GoChangelist'
        \ }

  let winid = popup_menu(s:change_info_list, popup_config)

  call win_execute(winid, 'normal! G')
  call win_execute(winid, 'normal! \<c-b>')
endfunction

function! GoChangelist(id, result)
  let target_dict = s:change_info_list[a:result-1]
  execute target_dict['cmd']
  normal zz
endfunction
