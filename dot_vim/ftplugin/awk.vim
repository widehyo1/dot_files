setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2

iabbrev <buffer> \begin; BEGIN {<CR><C-u>}
iabbrev <buffer> \end; END {<CR><C-u>}
iabbrev <buffer> \for; for (i = 1; i <= NF; i++) {}
iabbrev <buffer> \forarr; for (idx in arr) {}
iabbrev <buffer> \printarr; for (idx in arr) {<CR>print "idx: " idx " arr[idx]: " arr[idx]<CR>}
iabbrev <buffer> \striparr; for (idx in arr) {<CR>arr[idx] = strip(arr[idx])<CR>}
iabbrev <buffer> \strip; function strip(str) {<CR>gsub(/^\s+\|\s+$/, "", str)<CR>return str<CR>}
iabbrev <buffer> \join; function join(arr, sep) {<CR>acc = arr[1]<CR>for (i = 2; i <= length(arr); i++) {<CR>acc = acc sep arr[i]<CR>}<CR>return acc<CR>}
iabbrev <buffer> \gsub; gsub(regex, replace, str)
iabbrev <buffer> \rindex; function rindex(hay, needle,    arr, lastToken) {<CR>lastToken = arr[split(hay, arr, needle)]<CR>return length(hay) - length(needle) - length(lastToken) + 1<CR>}
iabbrev <buffer> \common; @include "common.awk"
iabbrev <buffer> \csv; @include "csv.awk"
vnoremap <buffer> gcc :s/^/# /<CR>

iabbrev <buffer> \procinfo; old_procinfo = PROCINFO["sorted_in"]<CR>PROCINFO["sorted_in"] = "@val_num_asc"<CR><CR>PROCINFO["sorted_in"] = old_procinfo

nnoremap <buffer> <leader>rr :!awk -f %<CR>
