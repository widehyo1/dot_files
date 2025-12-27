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
