# heap.awk
# input: one-linear space separated integers
# invariant(min heap):
#   less_or_equal(i, left(i)) && less_or_equal(i, right(i))

function less(node_a, node_b) {
  return heap[node_a] < heap[node_b]
}

function left(i)   { return (i * 2 > heap_n) ? "" : i * 2 }
function right(i)  { return (i * 2 + 1 > heap_n) ? "" : i * 2 + 1 }
function parent(i) { return (i == 1) ? "" : int(i / 2) }

function heap_swap(a, b,   t) {
  t = heap[a]
  heap[a] = heap[b]
  heap[b] = t
}

function find_swap_idx(i,   min_idx) {
  if (!left(i)) return
  if (right(i)) {
    min_idx = less(left(i), right(i)) ? left(i) : right(i)
    if (less(min_idx, i)) return min_idx
  } else {
    if (less(left(i), i)) return left(i)
  }
}

function sift_down(i) {
  while((swap_idx = find_swap_idx(i))) {
    heap_swap(i, swap_idx)
    i = swap_idx
  }
}

function sift_up(i) {
  while (less(i, parent(i))) {
    heap_swap(i, parent(i))
    i = parent(i)
  }
}

function heappify() {
  for (i = int(heap_n / 2); i >= 1; i--) {
    sift_down(i)
  }
}

function heap_push(val) {
  heap[++heap_n] = val
  sift_up(heap_n)
}

function heap_pop(   res) {
  if (!heap_n) return
  res = heap[1]
  if (heap_n == 1) {
    delete heap[heap_n]
    heap_n--
    return res
  }
  heap[1] = heap[heap_n]
  delete heap[heap_n]
  heap_n--
  sift_down(1)
  return res
}

NR == 1 {
  delete heap
  heap_n = 0
  for (i = 1; i <= NF; i++) { arr[i] = $i }
  for (idx in arr) {
    print idx ": " arr[idx]
  }
  print "=== heap push ==="
  for (idx in arr) {
    heap_push(arr[idx])
  }
  for (i = 1; i <= heap_n; i++) {
    print "heap[" i "] = " heap[i]
  }
  print "=== heap pop ==="
  while (heap_n) {
    print heap_pop()
  }
  delete heap
  print ""
  print "=== heappify ==="
  heap_n = split($0, heap)
  heappify()
  for (i = 1; i <= heap_n; i++) {
    print "heap[" i "] = " heap[i]
  }

  print "=== heap pop ==="
  while (heap_n) {
    print heap_pop()
  }

}
