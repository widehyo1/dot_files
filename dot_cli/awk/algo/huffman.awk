# huffman.awk
#
# struct {
#   left: node_id,
#   right: node_id,
#   char: str,
#   freq: int,
#   leftmost: str
# } node
#
# heap consists of node id
#
# heap operation works on index
#
# invariant:
#   heap_less_or_equal(idx, heap_left(idx)) only if heap_left exists
#   heap_less_or_equal(idx, heap_right(idx)) only if heap_right exists

function less(na, nb) {
  if (node[na, "freq"] != node[nb, "freq"]) return node[na, "freq"] < node[nb, "freq"]
  return node[na, "leftmost"] < node[nb, "leftmost"]
}

function heap_less(ha, hb) {
  return less(heap[ha], heap[hb])
}

function left(idx) {
  return idx * 2 > heap_n ? "" : idx * 2
}

function right(idx) {
  return (idx * 2 + 1) > heap_n ? "" : idx * 2 + 1
}

function parent(idx) {
  return idx == 1 ? "" : int(idx / 2)
}

function heap_swap(a, b,   t) {
  t = heap[a]
  heap[a] = heap[b]
  heap[b] = t
}

function find_swap_idx(idx,   min_idx, r) {
  if (!left(idx)) return ""
  min_idx = left(idx)
  r = right(idx)
  if (r && heap_less(r, min_idx)) min_idx = r
  return heap_less(min_idx, idx) ? min_idx : ""
}

function sift_down(idx,   swap_idx) {
  while (swap_idx = find_swap_idx(idx)) {
    heap_swap(idx, swap_idx)
    idx = swap_idx
  }
}

function sift_up(idx,   p) {
  while (p = parent(idx)) {
    if (!heap_less(idx, p)) break
    heap_swap(p, idx)
    idx = p
  }
}

function heap_push(node) {
  heap[++heap_n] = node
  sift_up(heap_n)
}

function heap_pop(   res) {
  if (!heap_n) return ""
  res = heap[1]
  if (heap_n == 1) {
    delete heap[heap_n--]
    return res
  }
  heap_swap(1, heap_n)
  delete heap[heap_n--]
  sift_down(1)
  return res
}

function heappify() {
  for (i = int(heap_n / 2); i >= 1; i--) {
    sift_down(i)
  }
}

function node_new(char, freq, left, right, leftmost) {
  nid++
  node[nid, "char"] = char
  node[nid, "freq"] = freq
  node[nid, "left"] = left ? left : 0
  node[nid, "right"] = right ? right : 0
  node[nid, "leftmost"] = leftmost ? leftmost : char
  return nid
}

function merge(na, nb,   t) {
  t = node[na, "leftmost"] < node[nb, "leftmost"] ? node[na, "leftmost"] : node[nb, "leftmost"]
  return node_new("", node[na, "freq"] + node[nb, "freq"], na, nb, t)
}

function build_root(   na, nb, res) {
  if (!heap_n) return ""
  if (heap_n == 1) return heap[heap_n]
  while (heap_n > 1) {
    na = heap_pop()
    nb = heap_pop()
    res = merge(na, nb)
    heap_push(res)
  }
  return res
}

function build_converter(id, code) {
  if (node[id, "left"] == 0 && node[id, "right"] == 0) {
    encoder[node[id, "char"]] = code
    decoder[code] = node[id, "char"]
  }
  if (node[id, "left"]) build_converter(node[id, "left"], code "0")
  if (node[id, "right"]) build_converter(node[id, "right"], code "1")
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

function build_counter(str) {
  for (i = 1; i <= length(str); i++) {
    counter[substr(str, i , 1)] += 1
  }
}

NR == 1 {
  build_counter($0)
  for (char in counter) {
    id = node_new(char, counter[char])
    heap_push(id)
  }
  root = build_root()
  build_converter(root, "")
  enc = encode($0)
  print enc
  dec = decode(enc)
  print dec
}
