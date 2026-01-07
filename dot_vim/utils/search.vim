function! Lgrep(search_text = '')
  let bufnr = bufnr()
  let search_text = empty(a:search_text) ? @/ : a:search_text
  let search_text = "'" . search_text . "'"
  lexpr []
  execute 'lgrep ' . search_text . ' ' . fnamemodify(getcwd(), ':h')
  if bufnr != bufnr()
    edit #
  endif
endfunction
