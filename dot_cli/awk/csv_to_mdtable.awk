@include "common"
@include "functool"

function getname(name) {
  return format("%"maxlen"s", name)
}

function todash(str) {
  gsub(/./, "-", str)
  return str
}

function predicate(str) {
  return length(str) > 2
}

BEGIN {
  FS = ","
  maxlen = 0
}

NR == 1 {
  for (i = 1; i <= NF; i++) {
    if (length($i) > maxlen) maxlen = length($i)
    headers[i] = $i
  }
}
NR > 1 {
  for (i = 1; i <= NF; i++) {
    if (length($i) > maxlen) maxlen = length($i)
    contents[NR][i] = $i
  }
}
END {
  apply(headers, "getname")
  print join(headers, "|", "|", "|")
  map(headers, "todash", splitlines)
  print join(splitlines, "|", "|", "|")
  for (idx = 2; idx <= length(contents); idx++) {
    apply(contents[idx], "getname")
    print join(contents[idx], "|", "|", "|")
  }
}

