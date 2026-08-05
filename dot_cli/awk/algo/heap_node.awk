# heap_node.awk
# struct {
#   left: node_id,
#   right: node_id,
#   char: str,
#   freq: int,
#   leftmost: str
# }
#
# heap consists of node ids
# heap operation works on heap index
#
# idx is leaf iff heap_left(idx) == ""
# idx is internal iff heap_left(idx) != ""
# invariant:
#   heap_less(internal_idx, heap_left(internal_idx))
#   heap_less(internal_idx, heap_right(internal_idx)), only if heap_right exists

function less(na, nb) {
  if (freq[na] != freq[nb]) return freq[na] < freq[nb]
  return leftmost[na] < leftmost[nb]
}

function heap_less(ha, hb) {
  return less(heap[ha], heap[hb])
}

function heap_parent(idx) {
  if (idx == 1) return ""
  return int(idx / 2)
}

function heap_left(idx) {
  return idx * 2 > heap_n ? "" : idx * 2
}

function heap_right(idx) {
  return (idx * 2 + 1) > heap_n ? "" : (idx * 2 + 1)
}

function find_swap_idx(idx,   min_idx, hr) {
  if (!heap_left(idx)) return ""
  min_idx = heap_left(idx)
  hr = heap_right(idx)
  if (hr && heap_less(hr, min_idx)) min_idx = hr
  return heap_less(min_idx, idx) ? min_idx : ""
}

function heap_swap(ha, hb,   t) {
  t = heap[ha]
  heap[ha] = heap[hb]
  heap[hb] = t
}

function sift_up(idx,   parent) {
  while (parent = heap_parent(idx)) {
    if (heap_less(parent, idx)) break
    heap_swap(parent, idx)
    idx = parent
  }
}

function sift_down(idx) {
  while (swap_idx = find_swap_idx(idx)) {
    heap_swap(swap_idx, idx)
    idx = swap_idx
  }
}

function heap_push(id) {
  heap[++heap_n] = id
  sift_up(heap_n)
}

function heap_pop(   id) {
  if (!heap_n) return ""
  id = heap[1]
  if (heap_n == 1) {
    delete heap[1]
    heap_n--
    return id
  }
  heap_swap(1, heap_n)
  delete heap[heap_n]
  heap_n--
  sift_down(1)
  return id
}

function heappify() {
  for (i = int(heap_n / 2); i >= 1; i--) {
    sift_down(i)
  }
}

