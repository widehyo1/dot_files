# Vim–terminal PWD bridge

이 기능은 범용 protocol 구현이 아니라 local workflow용입니다.

1. Bash는 prompt 변경 때 OSC 7과 Vim terminal JSON API로 `PWD`를 보냅니다: [`vimrc`](https://github.com/widehyo1/dot_files/blob/main/dot_config/bash/cli/vimrc#L1-L14).
2. [`Tapi_SetOsc7_Dir()`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/utils/terminal.vim#L120-L122)가 이를 terminal buffer의 `osc7_dir`에 저장합니다.
3. terminal buffer의 `<leader>cd`는 [`SyncTerminalPwd()`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/autocmd/terminal.vim#L7-L28)를 호출하고, 존재하는 경로이면 `:cd`를 실행합니다.
4. terminal-open mode 1은 Vim의 `getcwd()`를 shell로 보냅니다: [`OpenTerminalBuffer()`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/utils/terminal.vim#L39-L52).

코드와 함께 `:help terminal-api`, `:help term_setapi()`, `:help :cd`, `:help :lcd`, `:help :tcd`, `:help getcwd()`를 읽으면 됩니다. 전역 `:cd` 사용은 single-workspace workflow에는 의도적이지만 multi-project tab에는 맞지 않을 수 있습니다.
