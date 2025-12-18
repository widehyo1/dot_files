{
  for (i = 1; i <= NF; i++) {
    arr[NR][i] = $i
  }
}
END {
  for (i = 1; i <= NF; i++) {
    str = ""
    for (nr in arr) {
      str = str sprintf("%s,", arr[nr][i])
    }
    out[i] = substr(str, 1, length(str) - 1)
  }
  for (idx in out) {
    print out[idx]
  }
}
