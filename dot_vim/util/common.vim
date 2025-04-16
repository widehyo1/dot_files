function! CopyPwd()
    redir @"
    execute 'echo fnamemodify(expand("%"), ":~:.")'
    redir END
    let @+ = @"
endfunction

function! JqYankVisual()
    let l:sel = join(getline("'<", "'>"), "\n")
    let l:result = system('jq -f ~/script.jq', l:sel)
    call setreg('+', l:result)
endfunction

function! AwkYankVisual()
    let l:sel = join(getline("'<", "'>"), "\n")
    let l:result = system('awk -f ~/script.awk', l:sel)
    call setreg('+', l:result)
endfunction

function! CamelToSnake(text)
  return substitute(a:text, '\(\u\)', '_\L\1', 'g')
endfunction

function! SnakeToCamel(text)
  let l:lst = split(a:text, '_')
  let l:camel = l:lst[0]
  for l:item in l:lst[1 :]
    let l:camel = l:camel . toupper(l:item[0]) . l:item[1 :]
  endfor
  return l:camel
endfunction

function! ReplaceCursorWord(target)
  let @+=a:target
  normal viwp
endfunction

" Main function to toggle between snake_case and CamelCase
function! ToggleSnakeCamel()
  " Get cursor infomations
  let l:word = expand('<cword>')

  " Remove leading underscores if present
  let l:text = substitute(l:word, '^_+', '', '')

  " Initialize the result variable
  let l:result = l:text

  " Check if the word is in snake_case (contains an underscore) or CamelCase
  if match(l:text, '_') > 0
    echo 'snake case found, snake to camel'
    " If the word contains underscores, convert it to CamelCase
    let l:result = SnakeToCamel(l:text)
  elseif match(l:text, '[[:upper:]]') > 0
    echo 'camel case found, camel to snake'
    " If the word contains uppercase letters, convert it to snake_case
    let l:result = CamelToSnake(l:text)
  else
    echo 'return it unchanged'
    let l:result = l:word
  endif

  call ReplaceCursorWord(l:result)
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
  let grep_result = system('grep -Irn --include=*.py --exclude-dir=.venv ' . a:search_text)
  let search_results = grep_result->split('\n')
  if len(search_results) == 0
    let popup_config = #{
    \   time: 3000,
    \   highlight: 'WarningMsg'
    \ }
    let empty_msg = 'there is no buffer with name matching ' . a:search_text
    call popup_menu(empty_msg, popup_config)
    return
  endif
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

function! ListToString(list, sep=' ', start='[', end=']')
  return a:start .. ' ' .. join(copy(a:list), a:sep) .. ' ' .. a:end
endfunction

function! DictToString(dict, sep=', ')
  return '{ ' .. copy(a:dict)->map(' v:key .. ": " .. v:val ')->values()->join(a:sep) .. ' }'
endfunction

function! DictListToString(list, sep=' ')
  return ListToString(copy(a:list)->map('DictToString(v:val)'), a:sep)
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
    eelseif a:key ==# "7"
        call win_execute(a:winid, "normal! 70%")
    elseif a:key ==# "8"
        call win_execute(a:winid, "normal! 80%")
    elseif a:key ==# "9"
        call win_execute(a:winid, "normal! 90%")
    elseif a:key ==# 'q'
        call popup_close(a:winid)
    else
        return v:false
    endif
    return v:true
endfunction

function! PopupFilter(winid, key) abort
    if a:key ==# 'q'
        call popup_close(a:winid)
    else
        return v:false
    endif
    return v:true
endfunction
