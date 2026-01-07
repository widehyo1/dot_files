" insert to normal
inoremap jj <ESC>
inoremap JJ <ESC>

" toggle shell
nnoremap <C-D> <cmd>sh<cr>

" preserve original keymap
nnoremap <leader><C-D> <C-D>

" line
nnoremap <C-Up> <cmd>m .-2<CR>==
nnoremap <C-Down> <cmd>m .+1<CR>==

" window
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k

" window split
nnoremap <leader>ws <C-W><C-S>
nnoremap <leader>wv <C-W><C-V>

" window split new
nnoremap <leader>wns <cmd>new<CR>
nnoremap <leader>wnv <cmd>vnew<CR>

" window resize
nnoremap <leader>wwr <C-W>=
nnoremap <leader>wwv <C-W>_
nnoremap <leader>wwh <C-W><bar>

" buffer
nnoremap <leader>q <cmd>bp<bar>bd #<CR>
nnoremap <leader>bf <cmd>bf<CR>
nnoremap <leader>bl <cmd>bl<CR>
nnoremap <leader>bdf <cmd>1,.-1bd!<CR>
nnoremap <leader>bdl <cmd>.+1,$bd!<CR>
nnoremap <leader>bonly <cmd>1,.-1bd!<Bar>.+1,$bd!<CR>
nnoremap <leader>ls <cmd>ls<CR>
nnoremap H <cmd>bp!<CR>
nnoremap L <cmd>bn!<CR>

" preserve original keymap
nnoremap <leader>H H
nnoremap <leader>L L

" rc
nnoremap <leader>rc <cmd>e ~/.vimrc<CR>
nnoremap <leader>brc <cmd>e ~/.bashrc<CR>
nnoremap <leader>common <cmd>e ~/.vim/common.vim<CR>
nnoremap <leader>play <cmd>e ~/.vim/playground.vim <CR>
nnoremap <leader>md <cmd>e $TODAYMD<CR>

" awk
nnoremap <leader>as <cmd>e ~/script.awk<CR>
nnoremap <leader>at <cmd>e ~/temp.txt<CR>
nnoremap <leader>ay <cmd>let @+ = system('awk -f ~/script.awk ~/temp.txt')<CR>
nnoremap <leader>ap <cmd>r ! awk -f ~/script.awk ~/temp.txt<CR>
vnoremap <leader>ap <cmd>! awk -f ~/script.awk<CR>

" sql
nnoremap <leader>ss <cmd>e ~/script.sql<CR>

" python
nnoremap <leader>ps <cmd>e ~/script.py<CR>

" ruby
nnoremap <leader>rs <cmd>e ~/script.rb<CR>

" surround
nnoremap <space>` yiwcw``"0P
vnoremap <space>` ygvc``"0P
nnoremap <space>" yiwcw"""0P
vnoremap <space>" ygvc"""0P
nnoremap <space>' yiwcw''"0P
vnoremap <space>' ygvc''"0P
nnoremap <space>( yiwcw()"0P
vnoremap <space>( ygvc()"0P
nnoremap <space>[ yiwcw[]"0P
vnoremap <space>[ ygvc[]"0P
nnoremap <space>< yiwcw<>"0P
vnoremap <space>< ygvc<>"0P
nnoremap <space>{ yiwcw{}"0P
vnoremap <space>{ ygvc{}"0P

" backtick
nnoremap <leader>`v /`/-1<CR>V?`?+1<CR>
nnoremap <leader>`y /`/-1<CR>V?`?+1<CR>y

" buffer pwd helper
nnoremap <leader>cd <cmd>cd %:h<bar>pwd<CR>
nnoremap <leader>pp <cmd>let @+ = expand('%:p')<bar>echo @+<CR>

" highlight off
nnoremap <leader>h <cmd>set nohlsearch<cr>

" local list
nnoremap <leader>lg :lgrep 
nnoremap <leader>lo :lopen<CR>
nnoremap <leader>lc :lclose<CR>
