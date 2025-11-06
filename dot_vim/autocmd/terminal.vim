" TermOpen 이벤트에 대한 자동 명령
augroup TerminalKeymaps
  autocmd!
  autocmd TerminalOpen * call s:SetupTerminalKeymaps()
augroup END

function! s:SetupTerminalKeymaps() abort
  setlocal hidden
  setlocal nonumber
  setlocal nolist
  setlocal nowrap
  " <C-D> : 이전 버퍼로 전환
  execute 'nnoremap <buffer> <C-D> :buffer! #<CR>'

  " <leader>cd : osc7_dir으로 pwd 설정
  execute 'nnoremap <buffer> <leader>cd :call SyncTerminalPwd()<CR>'

  " 터미널 모드에서 <C-Q> → <C-\><C-n> : Normal 모드로 진입
  execute 'tnoremap <buffer> <C-Q> <C-\><C-n>'

endfunction
