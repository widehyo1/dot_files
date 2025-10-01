NR == 1 {
  cmd = "date +'%F'"
  cmd | getline created_at
  close(cmd)
  print "created_at,filesystem,blocks,used,available,use,mounted_on"
  next
}
{
  printf "%s,%s,%s,%s,%s,%s,%s\n",created_at,$1,$2,$3,$4,$5,$6
}
