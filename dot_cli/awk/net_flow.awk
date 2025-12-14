function strip(str) {
  gsub(/^\s+|\s+$/, "", str)
  return str
}

BEGIN {
  FS = ","
  OFS = ","
  print "date","asset","net_income","score"
}
NR == 1 { next }
{
  net_income = $3 + $4 + $5 + $6
  score = strip($7)
  printf "%s,%s,%s,%s\n", $1, $2, net_income, score
}
