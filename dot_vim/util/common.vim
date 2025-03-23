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
