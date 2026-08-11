# merge_sort.awk
#
# struct {
#   argleft: int,
#   argright: int,
#   label: str
# } stack_node with id: snid
#
# label: "new" | "merge"
# at merge state(label) do merge(arr, left, mid, right)

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
    if (arr[p1] <= arr[p2]) {
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

function print_arr(arr) {
  if (!length(arr)) return
  printf "["
  for (i = 1; i <= length(arr); i++) {
    printf i == length(arr) ? arr[i] "]\n" : arr[i] ", "
  }
}


NR == 1 {
  n = split($0, arr)
  print "before"
  print_arr(arr)
  merge_sort(arr, 1, n)
  print "after"
  print_arr(arr)
}
