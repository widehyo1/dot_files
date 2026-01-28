function! LoadBuffer(id, result)
  let target_buffer = s:buf_dict[a:result - 1]
  execute 'buffer! ' . target_buffer.bufnr
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


" if given search text is empty, use last searched pattern instead
function! ProcessSearchText(search_text = '')
  let search_text = empty(a:search_text) ? @/ : a:search_text
  " 직전 검색 패턴(@/) \< \> 제거
  return substitute(search_text, '\\<\|\\>', '', 'g')
endfunction


function! FindFile(search_text = '')
  let search_text = ProcessSearchText(a:search_text)

  if executable('fd')
    let fd_results = system('fd ' . shellescape(search_text))->split('\n')
  else
    let search_text = '*' . search_text . '*'
    let fd_results = system('find . -type f -name ' . shellescape(search_text))->split('\n')
  endif

  if len(fd_results) == 0
    let popup_config = #{
    \   time: 3000,
    \   cursorline: 0,
    \   highlight: 'WarningMsg'
    \ }
    let empty_msg = 'there is no buffer with name matching ' . a:search_text
    call popup_menu(empty_msg, popup_config)
    return
  endif

  let s:fd_info_list = fd_results

  let popup_config = #{
  \   callback: 'EditBuffer'
  \ }
  call popup_menu(s:fd_info_list, popup_config)
endfunction


""" Popup handler start
function! EditBuffer(id, result)
  let target = s:fd_info_list[a:result - 1]
  execute 'edit! ' . target
endfunction


function! GoSelectedFile(id, result)
  let target_dict = s:search_info_list[a:result-1]
  execute target_dict['cmd']
  normal zz
endfunction
""" Popup handler end


function! ContentSearch(search_results, search_text)
  let s:search_info_list = []

  if len(a:search_results) == 0
    let popup_config = #{
    \   time: 3000,
    \   cursorline: 0,
    \   highlight: 'WarningMsg'
    \ }
    let empty_msg = 'there is no buffer with content matching ' . a:search_text
    call popup_menu(empty_msg, popup_config)
    return
  endif

  for search_result in a:search_results
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


function! SearchAcrossFiles(search_text = '')
  let search_text = ProcessSearchText(a:search_text)

  if executable('rg')
    let grep_result = system('rg --no-heading --with-filename --line-number ' . shellescape(search_text))
  else
    let grep_result = system('grep -Irn ' . shellescape(search_text))
  endif

  call ContentSearch(grep_result->split('\n'), search_text)
endfunction


function! SearchAcrossBuffers(search_text = '')
  let search_text = ProcessSearchText(a:search_text)

  let buf_files = map(filter(getbufinfo(), 'v:val.listed'), 'fnamemodify(expand(v:val.name), ":.:~")')
  let buf_files_str = buf_files->join(' ')

  if executable('rg')
    let cmd = 'rg --no-heading --with-filename --line-number ' . shellescape(search_text) . ' ' . buf_files_str
    let grep_result = system(cmd)
  else
    let cmd = 'grep -Irn ' . shellescape(search_text) . ' ' . buf_files_str
    let grep_result = system(cmd)
  endif

  call ContentSearch(grep_result->split('\n'), search_text)
endfunction
