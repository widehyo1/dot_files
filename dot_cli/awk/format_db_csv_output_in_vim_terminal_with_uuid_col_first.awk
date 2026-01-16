BEGIN {
  FS = ","
}
length($1) == 36 {
  print ""
}
{
  printf $0
}
