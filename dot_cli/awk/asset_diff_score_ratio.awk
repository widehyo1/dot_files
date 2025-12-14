function strip(str) {
  gsub(/^\s+|\s+$/, "", str)
  return str
}
BEGIN {
  FS = ","
  OFS = ","
  print "date,asset,score,asset_diff,ad-s,proportion"
}
NR == 1 {
  next
}
{
  cur = $2
  asset_diff = cur - prev
  score = strip($7)
  if (prev > 0) {
    if (score > 0) {
      printf "%s,%s,%s,%s,%s,%s\n",$1,cur,score,asset_diff, asset_diff - score, asset_diff / score
    } else {
      printf "%s,%s,%s,%s,%s,%s\n",$1,cur,score,asset_diff, asset_diff - score, "N/A"
    }
  } else {
    printf "%s,%s,%s,%s,%s,%s\n",$1,cur,score,"N/A","N/A","N/A"
  }
  prev = cur
}
