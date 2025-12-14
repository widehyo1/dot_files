BEGIN {
  FS = ","
  OFS = ","
  print "date","asset","prev_asset","asset_diff(yoy)","growth_rate"
}
{
  prev[NR] = $2
}
cnt < 12 {
  cnt += 1
  next
}
{
  p = prev[NR-12]
  if (p + 0 != p) next
  cur = $2
  asset_diff = cur - p
  print $1,$2,p,asset_diff,(asset_diff / p) * 100
}
