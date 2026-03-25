function join(arr, sep) {
  acc = arr[1]
  for (i = 2; i <= length(arr); i++) {
    acc = acc sep arr[i]
  }
  return acc
}

NR == 1 {
  cmd = "date -I"
  cmd | getline date
  close(cmd)
  print "date,source,size,used,avail,pcent,target"
  next
}

{
  split($0, arr)
  str = join(arr, ",")
  printf "%s,%s\n",date,str
}
