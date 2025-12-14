function strip(str) {
  gsub(/^\s+|\s+$/, "", str)
  return str
}
BEGIN {
  FS = ","
  OFS = ","
}
NR == 1 {
  printf "%s,sum\n", strip($0)
  next
}
{
  sum = 0
  for (i = 2; i <= NF; i++) {
    sum += $i
  }
  printf "%s,%s\n", strip($0), sum
}
