iabbrev \begin; BEGIN {<C-u>}
iabbrev \end; END {<C-u>}
iabbrev \for; for (i = 1; i <= NF; i++) {}
iabbrev \forarr; for (idx in arr) {}
iabbrev \surr; function surround_str(str, start, end) {return start str end}
iabbrev \split; split(str, arr, sep)
iabbrev \strip; function strip(str) {gsub(/^\s+\|\s+$/, "", str)return str}
iabbrev \join; function join(arr, sep) {acc = arr[1]for (i = 2; i <= length(arr); i++) {acc = acc sep arr[i]}return acc}
iabbrev \gsub; gsub(regex, replace, str)
