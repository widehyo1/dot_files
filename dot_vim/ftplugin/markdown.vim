iabbrev <buffer> \post; ---<CR>layout: post<CR>title: post title<CR>subtitle: post subtitle<CR>tags: [tag]<CR>comments: true<CR>author: widehyo<CR>---
iabbrev <buffer> \bash; ```bash<CR>```
iabbrev <buffer> \java; ```java<CR>```
iabbrev <buffer> \js; ```js<CR>```
iabbrev <buffer> \py; ```py<CR>```
iabbrev <buffer> \jq; ```jq<CR>```
iabbrev <buffer> \awk; ```awk<CR>```
iabbrev <buffer> \log; ```log<CR>```
iabbrev <buffer> \json; ```json<CR>```
iabbrev <buffer> \curl; ```curl<CR>```
iabbrev <buffer> \kt; ```kt<CR>```
iabbrev <buffer> \lua; ```lua<CR>```
iabbrev <buffer> \vim; ```vim<CR>```
iabbrev <buffer> \hs; ```hs<CR>```

iabbrev <buffer> \asm; ```asm<CR>%include "io64.inc"<CR><CR>section .text<CR>global CMAIN<CR>CMAIN:<CR>    ;write your code here<CR>xor rax, rax<CR>ret<CR><C-U>```
iabbrev <buffer> \datasection; section .data
iabbrev <buffer> \bsssection; section .bss
iabbrev <buffer> \textsection; section .text

nnoremap <buffer> <leader><leader>jld :g/\v(at java\.(util<BAR>lang)<BAR>at org\.springframework<BAR>at catalina<BAR>at org\.apache<BAR>at org\.jboss<BAR>at sun\.reflect<BAR>at javax\.servlet<BAR>at org\.thymeleaf<BAR>at jakarta\.servlet<BAR>at org\.keycloak<BAR>at java\.net)/d<CR>

function! PasteCodeBlock(info_string = '')
  call setline('.', '```' .. a:info_string)
  execute 'put'
  call setline(line('.') + 1, '```')
  silent! keeppatterns %s/\r//g
endfunction

command -nargs=? PasteCodeBlock :call PasteCodeBlock(<f-args>)
nnoremap <buffer> <space>p :PasteCodeBlock 
nnoremap <buffer> <space>` i`<C-R>0`
