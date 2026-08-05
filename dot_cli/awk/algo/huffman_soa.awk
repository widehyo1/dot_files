# huffman.awk
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

function sift_down(idx,   swap_idx) {
  while (swap_idx = find_swap_idx(idx)) {
    heap_swap(swap_idx, idx)
    idx = swap_idx
  }
}

function heap_push(id) {
  heap[++heap_n] = id
  sift_up(heap_n)
}

function heap_pop(   res) {
  if (!heap_n) return ""
  res = heap[1]
  if (heap_n == 1) {
    delete heap[1]
    heap_n--
    return res
  }
  heap_swap(1, heap_n)
  delete heap[heap_n]
  heap_n--
  sift_down(1)
  return res
}

function heappify() {
  for (i = int(heap_n / 2); i >= 1; i--) {
    sift_down(i)
  }
}

function node_new(ch, fq, le, ri, lm) {
  id++
  char[id] = ch
  freq[id] = fq
  left[id] = le ? le : 0
  right[id] = ri ? ri : 0
  leftmost[id] = lm ? lm : ch
  return id
}

function build_counter(str) {
  for (i = 1; i <= length(str); i++) {
    counter[substr(str, i, 1)] += 1
  }
}

function node_merge(na, nb,   new_id) {
  new_id = node_new("", freq[na] + freq[nb], na, nb, leftmost[na] < leftmost[nb] ? leftmost[na] : leftmost[nb])
  heap_push(new_id)
}

function build_root() {
  if (!heap_n) return ""
  if (heap_n == 1) return heap[1]
  while (heap_n > 1) {
    na = heap_pop()
    nb = heap_pop()
    node_merge(na, nb)
  }
  return heap[1]
}

function build_converter(node, code) {
  if (left[node] == 0 && right[node] == 0) {
    encoder[char[node]] = code
    decoder[code] = char[node]
    return
  }
  if (left[node]) build_converter(left[node], code "0")
  if (right[node]) build_converter(right[node], code "1")
}

function encode(str,   enc) {
  enc = ""
  for (i = 1; i <= length(str); i++) {
    enc = enc encoder[substr(str, i, 1)]
  }
  return enc
}

function decode(enc,   text, code) {
  text = ""
  code = ""
  for (i = 1; i <= length(enc); i++) {
    code = code substr(enc, i, 1)
    if (code in decoder) {
      text = text decoder[code]
      code = ""
    }
  }
  return text
}

NR == 1 {
  build_counter($0)
  for (ch in counter) {
    new_id = node_new(ch, counter[ch])
    heap_push(new_id)
  }
  root = build_root()
  build_converter(root, "")
  enc = encode($0)
  print enc
  dec = decode(enc)
  print dec
}
