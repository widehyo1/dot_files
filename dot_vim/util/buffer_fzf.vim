function! GetLoadedBufferList()
  let l:buf_info = getbufinfo()
  let l:listed_buffer_info = l:buf_info
        \ ->filter({_, val -> val.listed == 1 })
        \ ->map({_, val -> {'bufnr': val.bufnr, 'name': fnamemodify(expand(val.name), ":~:.")}})
  return l:listed_buffer_info
endfunction

function! GetSmithWatermanScore(search_word, buf_name)
  let l:tx = ' ' . a:search_word
  let l:ty = ' ' . a:buf_name

  " direction
  let l:up      = 0b001
  let l:left    = 0b010
  let l:upleft  = 0b100
  let l:default = 0b000

  let l:matrix = []
  let l:highest_scored_position_list = []
  let l:score = 0

  function! CalcElement(row, col, match = 3, mis_match = -3, gap_panalty = -2) closure
    " closure for calculate matrix element with free variables:
    " l:matrix, l:highest_scored_position_list, l:score, l:tx, l:ty
    " l:up, l:left, l:upleft, l:default

    let l:up_value = l:matrix[a:row - 1][a:col][0]
    let l:left_value = l:matrix[a:row][a:col - 1][0]
    let l:diag_value = l:matrix[a:row - 1][a:col - 1][0]

    let l:up_candidate = l:up_value + a:gap_panalty
    let l:left_candidate = l:left_value + a:gap_panalty

    let l:diag_candidate = l:diag_value + a:mis_match

    if l:tx[a:row] == l:ty[a:col]
      let l:diag_candidate = l:diag_value + a:match
    endif

    let l:element_value = max([l:up_candidate, l:left_candidate, l:diag_candidate])
    let l:element_direction = l:default

    if l:element_value < 0
      let l:matrix[a:row][a:col] = [0, 0]
      return max([l:score, l:element_value])
    endif

    if l:element_value == l:up_candidate
      let l:element_direction = or(l:element_direction, l:up)
    endif
    if l:element_value == l:left_candidate
      let l:element_direction = or(l:element_direction, l:left)
    endif
    if l:element_value == l:diag_candidate
      let l:element_direction = or(l:element_direction, l:upleft)
    endif

    let l:matrix[a:row][a:col] = [l:element_value, l:element_direction]

    if l:element_value > l:score
      if len(l:highest_scored_position_list) > 0
        call remove(l:highest_scored_position_list, 0, len(l:highest_scored_position_list)-1)
      endif
      call add(l:highest_scored_position_list, [a:row, a:col])
      return max([l:score, l:element_value])
    elseif l:element_value == l:score
      call add(l:highest_scored_position_list, [a:row, a:col])
      return max([l:score, l:element_value])
    else
      return max([l:score, l:element_value])
    endif
  endfunction

  " initialize matrix
  for i in range(len(l:tx))
      let l:matrix_row = []
      for j in range(len(l:ty))
        call add(l:matrix_row, [0,0])
      endfor
      call add(l:matrix, l:matrix_row)
  endfor

  for i in range(1, len(a:search_word))
    for j in range(1, len(a:buf_name))
      let l:score = CalcElement(i, j)
    endfor
  endfor

  let l:buf_name_position_list = []

  while len(l:highest_scored_position_list) > 0
    let l:cur_position = remove(l:highest_scored_position_list, -1)
    let [l:cur_row, l:cur_col] = l:cur_position
    let [l:cur_value, l:cur_direction] = l:matrix[l:cur_row][l:cur_col]

    if l:cur_value == 0
      break
    endif

    if and(l:cur_direction, l:up) > 0
      call insert(l:buf_name_position_list, -1)
      call add(l:highest_scored_position_list, [l:cur_row - 1, l:cur_col])
    endif
    if and(l:cur_direction, l:left) > 0
      " call insert(l:buf_name_position_list, l:cur_col - 1)
      call add(l:highest_scored_position_list, [l:cur_row, l:cur_col - 1])
    endif
    if and(l:cur_direction, l:upleft) > 0
      call insert(l:buf_name_position_list, l:cur_col - 1)
      call add(l:highest_scored_position_list, [l:cur_row - 1, l:cur_col - 1])
    endif
  endwhile

  return [l:score, l:buf_name_position_list]
endfunction

function! GetHighlightPosition(position)
  let l:flag = 0
  let l:prev = -1
  let l:start = -1
  let l:result = []
  for pos in a:position
    if l:flag
      if pos - l:prev == 1
        let l:prev = pos
      else
        let l:flag = 0
        call add(l:result, [l:start, pos])
      endif
    else
      let l:start = pos
      let l:prev = pos
      let l:flag = 1
    endif
  endfor
  if l:flag
    call add(l:result, [l:start, a:position[-1]])
  endif
  return l:result
endfunction

function! DecorateText(text, position_list)
  let l:result_text = ""
  let l:idx = 0
  for [start, end] in a:position_list
    let l:result_text = a:text[l:idx:start - 1] . '[' . a:text[start:end] . ']'
    let l:idx = end + 1
  endfor
  if l:idx != len(a:text)
    let l:result_text = l:result_text . a:text[l:idx:]
  endif
  return l:result_text
endfunction

function! ScoreSortKey(lhs, rhs)
  return a:rhs.score - a:lhs.score
endfunction

function! Helper(pop_bufnr, search_bufnr, contents)
  let l:is_search_buf = bufnr() == a:search_bufnr

  let l:head = a:contents[0]
  let l:ct = copy(a:contents)
  if has_key(l:head, 'decorated_text')
    let l:ct = filter(l:ct, {_, val -> val.score > 0})
    let l:ct = sort(l:ct, 'ScoreSortKey')
    let l:lines = copy(l:ct)
          \ ->map({_, val -> val.score . '	' . val.decorated_text})
  else
    let l:lines = copy(l:ct)
          \ ->map({_, val -> val.name})
  endif

  execute 'buffer!' . a:pop_bufnr
  setlocal modifiable
  normal ggdG
  call setbufline(a:pop_bufnr, 1, l:lines)
  setlocal nomodifiable

  if l:is_search_buf
    execute 'buffer!' . a:search_bufnr
    call cursor(1, 9999)
  endif
  redraw
  return l:ct[0].bufnr
endfunction

function! PopupBuffer()

  " Function to capture and echo the text in the search buffer
  function! CaptureSearchText() closure
    " Get the content of the search buffer
    let l:search_buffer_lines = getline(1,'$')
    if len(l:search_buffer_lines) > 1
      execute 'quit!'
      execute 'quit!'
      execute 'buffer! ' . l:target_bufnr
      return
    endif
    let l:search_word = join(getline(1,1), '')
    " initialize temp register
    if l:search_word == ''
      call RedrawBufferList(l:buffer_info_list, 0)
    else
      call SmithWaterman(l:search_word, l:buffer_info_list)
    endif
  endfunction

  function! SmithWaterman(search_word, buffer_info_list) closure
    let l:filtered_buffer_list = []
    for l:buffer_info in copy(a:buffer_info_list)
      let [l:score, l:position] = GetSmithWatermanScore(a:search_word, l:buffer_info.name)
      if l:score > 0
        let l:hlpos = GetHighlightPosition(l:position)
        let l:target_buf_info = {}
        let l:target_buf_info.score = l:score
        let l:target_buf_info.hlposition = l:hlpos
        let l:target_buf_info.decorated_text = DecorateText(l:buffer_info.name, l:hlpos)
        let l:target_buf_info = extend(l:target_buf_info, l:buffer_info)
        call add(l:filtered_buffer_list, l:target_buf_info)
      endif
    endfor

    call RedrawBufferList(l:filtered_buffer_list, 1)
  endfunction

  function! RedrawBufferList(buffers, flag) closure

    let l:buf_len = len(a:buffers)

    if a:flag == 0

      if l:buf_len == 0
        let l:target_bufnr = Helper(l:pop_bufnr, l:search_bufnr, l:target_buffer_list)
        return
      endif

      let l:target_buffer_list = copy(a:buffers)
      let l:target_bufnr = Helper(l:pop_bufnr, l:search_bufnr, l:target_buffer_list)
      return
    else
      let l:target_buffer_list = [{'name': 'there is no searched buffer', 'bufnr': -1}]
      if l:buf_len == 0
        let l:target_bufnr = Helper(l:pop_bufnr, l:search_bufnr, l:target_buffer_list)
        return
      endif
      let l:target_buffer_list = copy(a:buffers)
      let l:target_bufnr = Helper(l:pop_bufnr, l:search_bufnr, l:target_buffer_list)
      return
    endif
  endfunction

  let l:search_word = ''
  let l:buffer_info_list = GetLoadedBufferList()
  let l:target_buffer_list = [{'name': 'there is no loaded buffer', 'bufnr': -1}]
  let l:target_bufnr = -1

  new
  let l:pop_bufnr = bufnr()
  setlocal buftype=nofile
  setlocal filetype=bufpop
  setlocal noswapfile
  setlocal nobuflisted
  setlocal nomodifiable
  resize 20

  new
  let l:search_bufnr = bufnr()
  setlocal buftype=nofile
  setlocal filetype=search
  setlocal noswapfile
  setlocal nobuflisted
  resize 1

  " echo l:pop_bufnr . ' ' . ' ' . l:search_bufnr
  call RedrawBufferList(l:buffer_info_list, 0)

  redraw

endfunction
