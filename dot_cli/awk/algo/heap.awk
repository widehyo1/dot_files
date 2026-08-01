# heap.awk
# input: one-linear space separated integers
# invariant(min heap):
#   heap[i] <= heap[2*i] && heap[i] <= heap[2*i + 1]
function heap_swap(a, b,   tmp) {
  tmp = heap[a]
  heap[a] = heap[b]
  heap[b] = tmp
}
function find_swap_idx(idx,   n, min_idx) {
  n = length(heap)
  # leaf node: vaild
  if (idx * 2 > n) return 0
  # internal node: check invariant
  if (idx * 2 == n) return heap[idx] > heap[idx * 2] ? idx * 2 : 0
  min_idx = heap[idx * 2] < heap[idx * 2 + 1] ? idx * 2 : idx * 2 + 1
  return heap[idx] > heap[min_idx] ? min_idx : 0
}
function sift_down(pos,   swap_idx) {
  while ((swap_idx = find_swap_idx(pos))) {
    heap_swap(pos, swap_idx)
    pos = swap_idx
  }
}
function sift_down_recursion(pos,   swap_idx) {
  swap_idx = find_swap_idx(pos)
  # base condition
  if (swap_idx == 0) return

  heap_swap(pos, swap_idx)
  sift_down_recursion(swap_idx)

}
function heappify(   pos) {
  for (pos = int(length(heap) / 2); pos >= 1; pos--) {
    # sift_down(pos)
    sift_down_recursion(pos)
  }
}
function sift_up(idx,   parent) {
  while ((parent = int(idx / 2))) {
    if (heap[parent] <= heap[idx]) break
    heap_swap(parent, idx)
    idx = parent
  }
}
function sift_up_recursion(idx,   parent) {
  parent = int(idx / 2)
  # base condition
  if (parent == 0) return
  # biz logic
  if (heap[parent] > heap[idx]) {
    heap_swap(parent, idx)
    sift_up_recursion(parent)
  }
}
function heap_push(val,   n) {
  n = length(heap)
  heap[++n] = val
  sift_up(n)
  # sift_up_recursion(n)
}
function heap_pop(   res) {
  n = length(heap)
  if (n == 0) return ""
  res = heap[1]
  if (n == 1) {
    delete heap[1]
    return res
  }
  heap[1] = heap[n]
  delete heap[n]
  sift_down(1)
  return res
}
NR == 1 {
  print "[heappify]"
  split($0, heap)
  n = length(heap)
  print "=== before ==="
  for (idx in heap) {
    print heap[idx]
  }
  heappify()
  print "=== after ==="
  for (idx in heap) {
    print heap[idx]
  }
  delete heap
  print ""
  print "[heap_push]"
  n = split($0, arr)
  print "=== befor ==="
  for (idx in arr) {
    print arr[idx]
  }
  for (idx = 1; idx <= n; idx++) {
    heap_push(arr[idx])
  }
  print "=== after ==="
  for (idx in heap) {
    print heap[idx]
  }
  while (length(heap)) {
    print heap_pop()
  }
}
