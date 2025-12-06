BEGIN {
  RS = ""
  FS = "\n"
}
NR == 1 {
  for (i = 1; i <= NF; i++) {
    n = split($i, arr, "|")
    if (n == 9 && $i !~ /Column/) {
      left[strip(arr[1])]++
    }
  }
}
NR == 2 {
  for (i = 1; i <= NF; i++) {
    n = split($i, arr, "|")
    if (n == 9 && $i !~ /Column/) {
      right[strip(arr[1])]--
    }
  }
}
END {
  for (i in left) {
    both[i] += left[i]
  }
  for (i in right) {
    both[i] += right[i]
  }
  for (idx in both) {
    print both[idx], idx
  }
}
