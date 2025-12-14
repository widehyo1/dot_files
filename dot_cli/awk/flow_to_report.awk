function strip(str) {
  gsub(/^\s+|\s+$/, "", str)
  return str
}

BEGIN {
  FS = ","
  OFS = ","
  print "date,net_income,score,expance,ratio"
}
NR == 1 { next }
{
  net_income = $3 + $4 + $5 + $6
  score = strip($7)
  t_net_income += net_income
  t_score += score
  printf "%s,%s,%s,%s,%s\n", $1, net_income, score, net_income - score, score / net_income
}
END {
  printf "total_net_income: %s, total_score: %s, ratio: %s\n", t_net_income, t_score, t_score / t_net_income
}
