function! Lgrep(...)
  let search_text = a:000->get(0, '')
  let bufnr = bufnr()
  let search_text = empty(search_text) ? @/ : search_text
  let search_text = "'" . search_text . "'"
  lexpr []
  execute 'lgrep ' . search_text . ' ' . fnamemodify(getcwd(), ':h')
  if bufnr != bufnr()
    edit #
  endif
endfunction

function! PasteSearchRegister()
    let word = substitute(@/, '\\<\|\\>\|\\V', '', 'g')
    call feedkeys('a' . word . "\<Esc>", 'n')
endfunction

function! SetSearchRegister()
    let word = substitute(@/, '\\<\|\\>\|\\V', '', 'g')
    call setreg('+', word)
endfunction
