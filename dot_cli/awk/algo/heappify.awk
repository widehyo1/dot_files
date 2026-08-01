# heappify.awk
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
function heappify(   pos) {
  for (pos = int(length(heap) / 2); pos >= 1; pos--)
      sift_down(pos)
}
NR == 1 {
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
}
