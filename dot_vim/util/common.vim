function! CopyPwd()
    redir @"
    execute 'echo fnamemodify(expand("%"), ":~:.")'
    redir END
    let @+ = @"
endfunction

function! JqYankVisual()
    let sel = join(getline("'<", "'>"), "\n")
    let result = system('jq -f ~/script.jq', sel)
    call setreg('+', result)
endfunction

function! AwkYankVisual()
    let sel = join(getline("'<", "'>"), "\n")
    let result = system('awk -f ~/script.awk', sel)
    call setreg('+', result)
endfunction

function! CamelToSnake(text)
  return substitute(a:text, '\(\u\)', '_\L\1', 'g')
endfunction

function! SnakeToCamel(text)
  let lst = split(a:text, '_')
  let camel = lst[0]
  for item in lst[1 :]
    let camel = camel . toupper(item[0]) . item[1 :]
  endfor
  return camel
endfunction

function! ReplaceCursorWord(target)
  let @+=a:target
  normal viwpb
endfunction

" Main function to toggle between snake_case and CamelCase
function! ToggleSnakeCamel()
  " Get cursor infomations
  let word = expand('<cword>')

  " Remove leading underscores if present
  let text = substitute(word, '^_+', '', '')

  " Initialize the result variable
  let result = text

  " Check if the word is in snake_case (contains an underscore) or CamelCase
  if match(text, '_') > 0
    echo 'snake case found, snake to camel'
    " If the word contains underscores, convert it to CamelCase
    let result = SnakeToCamel(text)
  elseif match(text, '[[:upper:]]') > 0
    echo 'camel case found, camel to snake'
    " If the word contains uppercase letters, convert it to snake_case
    let result = CamelToSnake(text)
  else
    echo 'return it unchanged'
    let result = word
  endif

  " replace the result in the buffer
  call ReplaceCursorWord(result)
endfunction

function! BufferMenu(search_text = '')
  " show loaded buffers on popup menu and open selected buffer
  let s:buf_dict = map(filter(getbufinfo(), 'v:val.listed'), '#{
        \ bufnr: v:val.bufnr,
        \ text: fnamemodify(expand(v:val.name), ":.:~")
        \ }')
  if len(a:search_text)
    " filter buf_dict text with search_text
    call filter(s:buf_dict, 'v:val.text =~ a:search_text')
    if len(s:buf_dict) == 0
      let popup_config = #{
      \   time: 3000,
      \   cursorline: 0,
      \   highlight: 'WarningMsg'
      \ }
      let empty_msg = 'there is no buffer with name matching ' . a:search_text
      call popup_menu(empty_msg, popup_config)
      return
    endif
  endif

  let popup_config = #{
  \   callback: 'LoadBuffer'
  \ }
  call popup_menu(s:buf_dict, popup_config)
endfunction

function! LoadBuffer(id, result)
  let target_buffer = s:buf_dict[a:result - 1]
  execute 'buffer! ' . target_buffer.bufnr
endfunction

function! SearchAcrossFiles(search_text)
  let grep_result = system('grep -Irn ' . a:search_text)
  let search_results = grep_result->split('\n')
  let s:search_info_list = []
  for search_result in search_results
    let info_dict = {}
    let length = len(search_result)
    let index = search_result->match(":", 0, 2)
    let file_info = search_result[:index-1]
    let [filename, linenumber] = file_info->split(':')
    let cmd = 'edit +' . linenumber . ' ' . filename
    let info_dict['cmd'] = cmd
    let info_dict['text'] = search_result[:length-2]
    call add(s:search_info_list, info_dict)
  endfor

  let popup_config = #{
        \ callback: 'GoSelectedFile',
        \ scrollbar: 1,
        \ maxheight: 20
        \ }

  call popup_menu(s:search_info_list, popup_config)
endfunction

function! GoSelectedFile(id, result)
  let target_dict = s:search_info_list[a:result-1]
  execute target_dict['cmd']
  normal zz
endfunction


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

function! BufferTabline()
  let curBuf = bufnr('%')

  let bufNameList = []

  for buf in filter(getbufinfo(), 'v:val.listed')
    let bufName = ''
    if buf.name == ''
      let bufName = '[No Name]'
    else
      let bufName = fnamemodify(expand(buf.name), ':.:t')
    endif
    if buf.changed == 1
      let bufName = bufName .. ' +'
    endif
    if buf.bufnr == curBuf
      let bufName = '< ' .. bufName .. ' >'
    endif
    call add(bufNameList, bufName)
  endfor

  let bufNameStr = join(bufNameList, ' | ')
  return bufNameStr
endfunction

function! PrintOpenTerminalMode()
  echomsg 'choice: ' .. g:open_terminal_mode .. ' [:sh(0), :terminal with sync buffer pwd(1), :terminal(2), :terminal in new buffer(3)]'
endfunction

function! ToggleOpenTerminalMode()
  let g:open_terminal_mode = (g:open_terminal_mode + 1) % 4
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

        if g:open_terminal_mode == 3
          execute 'vsplit'
        endif
        execute 'buffer! ' .. bufnr
        if g:open_terminal_mode == 1
          let pwd = getcwd()
          " sync vim pwd
          call feedkeys("i\<C-u>cd " .. pwd .. "\<CR>")
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

function! SyncTerminalPwd()
  let term_bufnr = bufnr()
  let osc7_dir = getbufvar(term_bufnr, 'osc7_dir')
  if isdirectory(osc7_dir)
    echo 'osc7_dir: ' .. osc7_dir
    execute 'cd ' .. osc7_dir
  endif
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
