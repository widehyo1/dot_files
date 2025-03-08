NR == 1 {
  to = $0
}
NR > 1 {
  to = to "<CR>" $0
}
END {
  print "inoremap \\abbr; " to
}
