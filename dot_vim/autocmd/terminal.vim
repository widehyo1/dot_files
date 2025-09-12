" TermOpen 이벤트에 대한 자동 명령
augroup TerminalKeymaps
  autocmd!
  autocmd TerminalOpen * call s:SetupTerminalKeymaps()
augroup END

function! s:SetupTerminalKeymaps() abort
  " <C-D> : 이전 버퍼로 전환
  execute 'nnoremap <buffer> <C-D> :buffer! #<CR>'

  " gf : 새 윈도우에서 파일 열기
  execute 'nnoremap <buffer> gf <C-W><C-F>'

  " 터미널 모드에서 <C-Q> → <C-\><C-n> : Normal 모드로 진입
  execute 'tnoremap <buffer> <C-Q> <C-\><C-n>'

endfunction
