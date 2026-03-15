function join(arr, sep) {
  acc = arr[1]
  for (i = 2; i <= length(arr); i++) {
    acc = acc sep arr[i]
  }
  return acc
}

function strip(str) {
  gsub(/^\s+|\s+$/, "", str)
  return str
}

FNR == 1 {
  filename = path_arr[split(FILENAME,path_arr,"/")]
  table_name = substr(filename, 1, index(filename, ".") - 1)
  split($0, arr, ",")
  print "create table " table_name "("
  str = join(arr, " text,\n")
  print strip(str) " text"
  print ");"
}
