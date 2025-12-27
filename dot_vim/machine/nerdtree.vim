" nerdtree autocmd group NERDTree
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

nnoremap <leader>. :NERDTreeFind<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
