iabbrev <buffer> \begin; BEGIN {<CR><C-u>}
iabbrev <buffer> \end; END {<CR><C-u>}
iabbrev <buffer> \for; for (i = 1; i <= NF; i++) {}
iabbrev <buffer> \forarr; for (idx in arr) {}
iabbrev <buffer> \surr; function surround_str(str, start, end) {<CR>return start str end<CR>}
iabbrev <buffer> \split; split(str, arr, sep)
iabbrev <buffer> \strip; function strip(str) {<CR>gsub(regex, replace, str)<CR>return str<CR>}
iabbrev <buffer> \join; function join(arr, sep) {<CR>acc = arr[1]<CR>for (i = 2; i <= length(arr); i++) {<CR>acc = acc sep arr[i]<CR>}<CR>return acc<CR>}

setlocal tabstop=2
setlocal shiftwidth=2
vnoremap <buffer> gcc :s/^/# /<CR>
