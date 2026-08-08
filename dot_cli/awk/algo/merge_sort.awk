# merge_sort.awk

function merge(arr, left, mid, right,   temp, p1, p2, tn) {
  delete temp
  p1 = left; p2 = mid + 1;

  while (1) {
    # base condition1: exhaust left array
    if (p1 > mid) {
      while (p2 <= right) {
        temp[++tn] = arr[p2++]
      }
      break
    }
    # base condition2: exhaust right array
    if (p2 > right) {
      while (p1 <= mid) {
        temp[++tn] = arr[p1++]
      }
      break
    }
    if (arr[p1] <= arr[p2]) {
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

function print_arr(arr) {
  n = length(arr)
  if (n == 0) {
    print "[]"
    return
  }
  if (n == 1) {
    print "[" arr[1] "]"
    return
  }
  printf "["
  for (i = 1; i <= n; i++) {
    printf i == n ? arr[i] "]\n" : arr[i] ", "
  }
}

{
  n = split($0, arr)
  print_arr(arr)
  merge_sort(arr, 1, n)
  print_arr(arr)
}
