@load "/home/widehyo/.cli/awk/lib/csv.awk"

BEGIN {
  CSVMODE = 1
}
# header
NR == 1 {
  nf = csvsplit(CSVRECORD, headers)
  next
}
# row validation
NF != nf {
  print "invaild csv: different column found"
  exit
}
# business
{
  # logic
}
