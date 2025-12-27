nnoremap <leader>cs :e ~/script.curl<CR>
nnoremap <leader>ct :e ~/request.json<CR>
nnoremap <leader>cy :let @+ = system('curl --config ~/script.curl')<CR>
nnoremap <leader>cp :r ! curl --config ~/script.curl<CR>
