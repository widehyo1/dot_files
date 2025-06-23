# assume arr is 1 based array from 1 to length(arr)
function join(arr, sep, start, end) {
  if (length(arr) == 0) return start end

  acc = (start ? start : "") arr[1]
  for (i = 2; i <= length(arr); i++) {
    acc = acc sep arr[i]
  }
  if (end) acc = acc end

  return acc
}

function joinAssoc(arr, sep, start, end) {

  origin_sort = PROCINFO["sorted_in"]
  PROCINFO["sorted_in"] = "@ind_str_asc"

  if (length(arr) == 0) return start end

  firstFlag = 1

  for (idx in arr) {
    if (firstFlag == 1) {
      acc = (start ? start : "") arr[idx]
      firstFlag = 0
      continue
    }
    acc = acc sep arr[idx]
  }
  if (end) acc = acc end

  PROCINFO["sorted_in"] = origin_sort
  return acc
}

function strip(str) {
  gsub(/^\s+|\s+$/, "", str)
  return str
}

function rindex(hay, needle,    arr, lastToken) {
  lastToken = arr[split(hay, arr, needle)]
  return length(hay) - length(needle) - length(lastToken) + 1
}

function format(fmt, target) {
  return sprintf(fmt, strip(target))
}
