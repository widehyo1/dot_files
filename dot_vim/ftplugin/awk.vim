iabbrev <buffer> \begin; BEGIN {<CR><C-u>}
iabbrev <buffer> \end; END {<CR><C-u>}
iabbrev <buffer> \for; for (i = 1; i <= NF; i++) {}
iabbrev <buffer> \forarr; for (idx in arr) {}
iabbrev <buffer> \printarr; for (idx in arr) {<CR>print "idx: " idx " arr[idx]: " arr[idx]<CR>}
iabbrev <buffer> \striparr; for (idx in arr) {<CR>arr[idx] = strip(arr[idx])<CR>}
iabbrev <buffer> \surr; function surround_str(str, start, end) {<CR>return start str end<CR>}
iabbrev <buffer> \surrd; "\""str"\""
iabbrev <buffer> \surrq; "'"str"'"
iabbrev <buffer> \surrp; "("str")"
iabbrev <buffer> \surrs; "["str"]"
iabbrev <buffer> \surrb; "<"str">"
iabbrev <buffer> \surrc; "{"str"}"
iabbrev <buffer> \split; split(str, arr, sep)
iabbrev <buffer> \strip; function strip(str) {<CR>gsub(/^\s+\|\s+$/, "", str)<CR>return str<CR>}
iabbrev <buffer> \join; function join(arr, sep,    acc) {<CR>acc = arr[1]<CR>for (i = 2; i <= length(arr); i++) {<CR>acc = acc sep arr[i]<CR>}<CR>return acc<CR>}
iabbrev <buffer> \gsub; gsub(regex, replace, str)
iabbrev <buffer> \rindex; function rindex(hay, needle,    arr, lastToken) {<CR>lastToken = arr[split(hay, arr, needle)]<CR>return length(hay) - length(needle) - length(lastToken) + 1<CR>}
iabbrev \include; @include "common"

setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
vnoremap <buffer> gcc :s/^/# /<CR>

nnoremap <buffer> <leader>rr :!awk -f %<CR>
