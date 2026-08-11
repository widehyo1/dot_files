# merge_sort.awk
#
# struct {
#   argleft: int,
#   argright: int,
#   label: str
# } stack_node with id: snid
#
# struct {
#   key: int,
#   data: int
# } node with id: nid
#
# label: "new" | "merge"
# at merge state(label) do merge(arr, left, mid, right)
#
# arr: consists of node ids

function node_le(nid_a, nid_b) {
  return key[nid_a] <= key[nid_b]
}

function le(idx_a, idx_b) {
  return node_le(arr[idx_a], arr[idx_b])
}

function merge(arr, left, mid, right,   temp, p1, p2, tn) {
  delete temp
  p1 = left; p2 = mid + 1

  # phase 1: construct temp array
  while (1) {
    # base condition1: exhausted left array
    if (p1 > mid) {
      while (p2 <= right) {
        temp[++tn] = arr[p2++]
      }
      break
    }
    # base condition2: exhausted right array
    if (p2 > right) {
      while (p1 <= mid) {
        temp[++tn] = arr[p1++]
      }
      break
    }
    # biz logic
    if (le(p1, p2)) {
      temp[++tn] = arr[p1++]
    } else {
      temp[++tn] = arr[p2++]
    }
  }

  # phase 2: replace array from left to right with temp array
  for (i = 1; i <= tn; i++) {
    arr[left - 1 + i] = temp[i]
  }
}

function stack_new(left, right, state) {
  _snid++
  argleft[_snid] = left
  argright[_snid] = right
  label[_snid] = state
  return _snid
}

function push(snid) {
  stack[++stack_n] = snid
}

function pop(   snid) {
  if (!stack_n) return
  snid = stack[stack_n]
  delete stack[stack_n--]
  return snid
}

function merge_sort(arr, left, right,   snid, state, mid) {
  push(stack_new(left, right, "new"))
  while (stack_n) {
    snid = pop()
    left = argleft[snid]
    right = argright[snid]
    state = label[snid]

    if (left >= right) continue
    mid = int((left + right) / 2)

    if (state == "new") {
      push(stack_new(left, right, "merge"))
      push(stack_new(mid + 1, right, "new"))
      push(stack_new(left, mid, "new"))
    } else if (state == "merge") {
      merge(arr, left, mid, right)
    }
  }
}

function node_new(k, d) {
  _nid++
  key[_nid] = k
  data[_nid] = d
  return _nid
}

NR == 1 {
  for (i = 1; i <= NF; i++) {
    arr[i] = node_new($i, i)
  }
  n = length(arr)
  merge_sort(arr, 1, n)
}
