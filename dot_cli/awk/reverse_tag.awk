/<chat>/ { in_block = 1; ++block_cnt; next }
/<\/chat>/ { in_block = 0; ; next }
in_block {
  arr[block_cnt] = sprintf("%s\n%s", arr[block_cnt], $0)
}
END {
  for (i = block_cnt; i >= 1; i--) {
    printf "<chat>%s\n</chat>\n", arr[i]
  }
}

