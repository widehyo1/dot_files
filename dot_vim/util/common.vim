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
  let l:line = line('.')
  let l:col = col('.')
  let l:line_text = getline(l:line)
  let l:word = expand('<cword>')
  " replace the result in the buffer
  let l:new_line = substitute(l:line_text, '\<' . l:word . '\>', a:target, '')
  call setline(l:line, l:new_line)
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

  " replace the result in the buffer
  call ReplaceCursorWord(l:result)
endfunction

function! InteractiveBufferList() abort
  " 현재 리스트된 버퍼 번호 목록을 가져옴
  let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  if empty(buffers)
    echo "사용 가능한 버퍼가 없습니다."
    return
  endif

  let selection = 0

  " 스크래치 버퍼를 새 창에 엽니다.
  new
  setlocal buftype=nofile
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal nobuflisted
  " 버퍼 내용을 수정할 수 없게 함
  setlocal nomodifiable
  " 창 크기를 적절하게 설정 (예: 20줄)
  resize 20

  " 최초 목록 표시 및 커서 위치 설정 (목록은 1번째 줄부터 시작)
  call s:DisplayBuffers(buffers, selection)
  redraw
  call cursor(1, 1)

  " 키 입력을 처리하는 루프
  while 1
    let key = getchar()
    if type(key) == type(0)
      " 숫자로 반환되는 경우 (예: 화살표 키)
      if key == 258 || key == char2nr('j')
        let selection = (selection + 1) % len(buffers)
      elseif key == 259 || key == char2nr('k')
        let selection = (selection - 1 + len(buffers)) % len(buffers)
      elseif key == 13
        " Enter키: 선택 완료
        break
      endif
    else
      " 문자로 반환되는 경우 (예: 'q'로 종료)
      if key ==# 'q'
        bd!
        return
      endif
    endif
    call s:DisplayBuffers(buffers, selection)
    redraw
    call cursor(1 + selection, 1)
  endwhile

  " 선택한 버퍼 번호를 가져와서 스크래치 버퍼를 닫은 후 전환
  let target_buf = buffers[selection]
  bd!
  execute 'buffer' target_buf
endfunction

function! s:DisplayBuffers(buffers, selection) abort
  let header = ['Interactive Buffer List (Use arrow keys or j/k, Enter: select, q: quit)', '']
  let lines = []
  for idx in range(len(a:buffers))
    let bufnum = a:buffers[idx]
    let name = bufname(bufnum)
    if name == ''
      let name = '[No Name]'
    endif
    if idx == a:selection
      call add(lines, '> ' . bufnum . ': ' . name)
    else
      call add(lines, '  ' . bufnum . ': ' . name)
    endif
  endfor
  setlocal modifiable
  call setline(1, header + lines)
  setlocal nomodifiable
endfunction
