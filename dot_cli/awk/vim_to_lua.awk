function strip(str) {
  gsub(/^\s+|\s+$/, "", str)
  return str
}
/^set/ {
  if ($0 ~ /=/) {
    split($0, arr, "=")
    printf "vim.o.%s = %s\n", substr($2, 1, index($2, "=") - 1), arr[2]
  } else {
    printf "vim.o.%s = true\n", $2
  }
}
/^nnoremap/ || /^vnoremap/ {
  # print $0
  split($0, arr, "\"")
  if (length(arr) > 1 && $2 !~ /"/) {
    # print arr[split($0, arr, "\"")]
    # print strip(substr($0, 1, index($0, arr[split($0, arr, "\"")]) - 2))
    $0 = strip(substr($0, 1, index($0, arr[split($0, arr, "\"")]) - 2))
  } else {
    gsub("'", "\"", $0)
    # print $0
  }
  # print "==="
  printf "vim.api.nvim_set_keymap('n', '%s', '%s', { noremap = true, silent = true })\n", $2, substr($0, index($0, $3))
}
