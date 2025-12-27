nnoremap <leader>js :e ~/script.jq<CR>
nnoremap <leader>jt :e ~/temp.json<CR>
nnoremap <leader>jy :let @+ = system('jq -r -f ~/script.jq ~/temp.json')<CR>
vnoremap <leader>jy :call JqYankVisual()<CR>
nnoremap <leader>jp :r ! jq -r -f ~/script.jq ~/temp.json<CR>
vnoremap <leader>jp :! jq -r -f ~/script.jq<CR>
vnoremap <leader>jf :! jq .<CR>
vnoremap <leader>jc :! jq -c .<CR>
