# Vim–terminal PWD bridge

This is a local workflow feature, not a portable protocol implementation.

1. Bash emits `PWD` through OSC 7 and Vim's terminal JSON API on prompt changes: [`vimrc`](https://github.com/widehyo1/dot_files/blob/main/dot_config/bash/cli/vimrc#L1-L14).
2. [`Tapi_SetOsc7_Dir()`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/utils/terminal.vim#L120-L122) stores it as `osc7_dir` on the terminal buffer.
3. Terminal-buffer `<leader>cd` calls [`SyncTerminalPwd()`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/autocmd/terminal.vim#L7-L28), which uses `:cd` when the directory exists.
4. Terminal-open mode 1 sends Vim's `getcwd()` to the shell: [`OpenTerminalBuffer()`](https://github.com/widehyo1/dot_files/blob/main/dot_vim/utils/terminal.vim#L39-L52).

Read `:help terminal-api`, `:help term_setapi()`, `:help :cd`, `:help :lcd`, `:help :tcd`, and `:help getcwd()` with the code. The use of global `:cd` is intentional for a single-workspace workflow; it may not suit multi-project tabs.
