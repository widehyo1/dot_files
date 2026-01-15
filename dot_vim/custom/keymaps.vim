" buffers
nnoremap <silent> <leader><leader><leader> <cmd>call BufferMenu()<CR>
command -nargs=1 BufferMenu :call BufferMenu(<f-args>)
nnoremap <leader><leader>s :BufferMenu 

" search across files
command -nargs=? SearchAcrossFiles :call SearchAcrossFiles(<f-args>)
nnoremap <leader><leader><C-F> :SearchAcrossFiles 

" find file
command -nargs=? FindFile :call FindFile(<f-args>)
nnoremap <leader><leader>f :FindFile 

" snake camel
nnoremap <F5> <cmd>call ToggleSnakeCamel()<CR>

" toggle terminal-vim
let g:open_terminal_mode = 0
nnoremap <C-D> <cmd>call OpenTerminal()<CR>
nnoremap <space><space><space> <cmd>call ToggleOpenTerminalMode()<CR>
nnoremap <space><space>0 <cmd>call SelectOpenTerminalMode(0)<CR>
nnoremap <space><space>1 <cmd>call SelectOpenTerminalMode(1)<CR>
nnoremap <space><space>2 <cmd>call SelectOpenTerminalMode(2)<CR>
nnoremap <space><space>3 <cmd>call SelectOpenTerminalMode(3)<CR>
nnoremap <space><space>p <cmd>call PrintOpenTerminalMode()<CR>

" terminal-esc
tnoremap <C-Q> <C-W>N
" paste register + (unnamed plus)
tnoremap <C-V> <C-W>"+

" floating window
nnoremap <leader>msg <cmd>call OpenExcommandPopup('messages', v:true)<CR>
nnoremap <leader>map <cmd>call OpenExcommandPopup('map')<CR>
nnoremap <leader>reg <cmd>call OpenExcommandPopup('registers')<CR>
nnoremap <leader>jumps <cmd>call OpenJumplistPopup()<CR>
nnoremap <leader>changes <cmd>call OpenChangelistPopup()<CR>
nnoremap <leader>history <cmd>call OpenExcommandPopup('history', v:true)<CR>
nnoremap <leader>undo <cmd>call OpenExcommandPopup('undo', v:true)<CR>
nnoremap <leader>autocmd <cmd>call OpenExcommandPopup('autocmd')<CR>

nnoremap <leader>af <cmd>call OpenSystemPopup('awk -f ~/script.awk ~/temp.txt')<CR>
nnoremap <leader>jf <cmd>call OpenSystemPopup('jq -f ~/script.jq ~/temp.json')<CR>

" Lgrep local-list
command -nargs=? Lgrep :call Lgrep(<f-args>)
nnoremap <leader>lg :Lgrep 
