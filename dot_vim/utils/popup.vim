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
        \ filter: 'PopupFilter',
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
        \ filter: 'PopupFilter',
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
