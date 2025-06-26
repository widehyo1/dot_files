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

function compareAssoc(assoc1, assoc2, res) {
  delete res
  for (idx1 in assoc1) {
    res[idx1]--
  }
  for (idx2 in assoc2) {
    res[idx2]++
  }
}

function compareArray(arr1, arr2, res) {
  delete res
  for (idx1 in arr1) {
    res[arr1[idx1]]--
  }
  for (idx2 in arr2) {
    res[arr2[idx2]]++
  }
}

function partition(str, sep, headtail) {
  headtail[1] = substr(str, 1, index(str, sep) - length(sep))
  headtail[2] = substr(str, index(str, sep) + length(sep))
}

function printArray(arr, arrName) {
  for (idx in arr) {
    printf "%s[%s]: %s\n", (arrName ? arrName : "arr"), idx, arr[idx]
  }
}

function flip(assoc) {
  for (idx in assoc) {
    assoc[assoc[idx]] = idx
  }
}

function zip(arr1, arr2, dict) {
  minlen = (length(arr1) < length(arr2) ? length(arr1) : length(arr2))
  for (i = 1; i <= minlen; i++) {
    dict[arr1[i]] = arr2[i]
  }
}
