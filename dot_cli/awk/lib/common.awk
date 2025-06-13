function join(arr, sep,    acc) {
  acc = arr[1]
  for (i = 2; i <= length(arr); i++) {
    acc = acc sep arr[i]
  }
  return acc
}
function rindex(hay, needle,    arr, lastToken) {
  lastToken = arr[split(hay, arr, needle)]
  return length(hay) - length(needle) - length(lastToken) + 1
}
function strip(str) {
  gsub(/^\s+|\s+$/, "", str)
  return str
}
