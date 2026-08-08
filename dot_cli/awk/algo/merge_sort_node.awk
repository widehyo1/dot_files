# merge_sort_node.awk
# 
# struct {
#   key: int,
#   data: int
# } node
#
# global node id is stored to _nid
# array consists of node ids

function node_new(k, d) {
  _nid++
  key[_nid] = k
  data[_nid] = d
  return _nid
}

function node_le(na, nb) {
  return key[na] <= key[nb]
}

function le(arr, idx_a, idx_b) {
  return node_le(arr[idx_a], arr[idx_b])
}

function merge(arr, left, mid, right,   temp, p1, p2, tn) {
  delete temp
  p1 = left; p2 = mid + 1
  while (1) {
    # base condition 1: left array exhausted
    if (p1 > mid) {
      while (p2 <= right) {
        temp[++tn] = arr[p2++]
      }
      break
    }
    # base condition 2: right array exhausted
    if (p2 > right) {
      while (p1 <= mid) {
        temp[++tn] = arr[p1++]
      }
      break
    }
    if (le(arr, p1, p2)) {
      temp[++tn] = arr[p1++]
    } else {
      temp[++tn] = arr[p2++]
    }
  }

  for (i = 1; i <= tn; i++) {
    arr[left - 1 + i] = temp[i]
  }

}

function merge_sort(arr, left, right,   mid) {
  if (left >= right) return
  mid = int((left + right) / 2)
  merge_sort(arr, left, mid)
  merge_sort(arr, mid + 1, right)

  merge(arr, left, mid, right)
}

function print_node(nid) {
  printf "{key: %s, data: %s}", key[nid], data[nid]
}

function print_arr(arr) {
  if (length(arr) == 0) {
    print "[]"
    return
  }
  printf "["
  for (i = 1; i <= length(arr); i++) {
    printf i == length(arr) ? print_node(arr[i]) "]\n" : print_node(arr[i]) ", "
  }
}



NR == 1 {
  n = length($0)
  for (i = 1; i <= n; i++) {
    arr[i] = node_new(substr($0, i, 1), i)
  }
  print_arr(arr)
  merge_sort(arr, 1, n)
  print_arr(arr)
}
