iabbrev <buffer> \post; ---<CR>layout: post<CR>title: post title<CR>subtitle: post subtitle<CR>tags: [tag]<CR>comments: true<CR>author: widehyo<CR>---
iabbrev <buffer> \awk; ```awk<CR>```
iabbrev <buffer> \bash; ```bash<CR>```
iabbrev <buffer> \curl; ```curl<CR>```
iabbrev <buffer> \java; ```java<CR>```
iabbrev <buffer> \jq; ```jq<CR>```
iabbrev <buffer> \js; ```js<CR>```
iabbrev <buffer> \json; ```json<CR>```
iabbrev <buffer> \log; ```log<CR>```
iabbrev <buffer> \py; ```py<CR>```
iabbrev <buffer> \sql; ```sql<CR>```
iabbrev <buffer> \kt; ```kt<CR>```
iabbrev <buffer> \lua; ```lua<CR>```
iabbrev <buffer> \vim; ```vim<CR>```
iabbrev <buffer> \hs; ```hs<CR>```

iabbrev <buffer> \asm; ```asm<CR>%include "io64.inc"<CR><CR>section .text<CR>global CMAIN<CR>CMAIN:<CR>    ;write your code here<CR>xor rax, rax<CR>ret<CR><C-U>```
iabbrev <buffer> \datasection; section .data
iabbrev <buffer> \bsssection; section .bss
iabbrev <buffer> \textsection; section .text

nnoremap <buffer> <leader><leader>jld :g/\v(java\.(util<BAR>lang)<BAR>springframework<BAR>catalina<BAR>org\.apache<BAR>org\.jboss<BAR>sun\.reflect<BAR>javax\.servlet)/d
