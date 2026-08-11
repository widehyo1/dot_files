# huffman.awk
#
# struct {
#   left: node_id,
#   right: node_id,
#   char: optional(char),
#   freq: int,
#   leftmost: char
# } node with id: nid
#
# where left (or right) is 0 is sentinel, no left (or right) node.
#
# queue1, queue2 conists of node ids
#
# struct {
#   argleft: int,
#   argright: int,
#   label: str
# } stack_node with id: snid
#
# represents explicit call stack within merge sort iteration
#
# struct {
#   start: int,
#   end: int
# } queue with id: qid
#

function node_new(ch, fq, l, r, lm) {
  _nid++
  left[_nid] = l ? l : 0
  right[_nid] = r ? r : 0
  char[_nid] = ch
  freq[_nid] = fq
  leftmost[_nid] = lm ? lm : ch
  return _nid
}

function node_le(nid1, nid2) {
  if (freq[nid1] != freq[nid2]) return freq[nid1] <= freq[nid2]
  return leftmost[nid1] <= leftmost[nid2]
}

function le(arr, a, b) {
  return node_le(arr[a], arr[b])
}

function enqueue(q, qid, nid) {
  q[++end[qid]] = nid
  if (!start[qid]) start[qid] = end[qid]
}

function dequeue(q, qid,   nid) {
  if (start[qid] > end[qid]) return
  nid = q[start[qid]++]
  return nid
}

function is_empty(qid) {
  return end[qid] ? start[qid] > end[qid] : 1
}

function front(q, qid) {
  if (is_empty(qid)) return
  return q[start[qid]]
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
    if (le(arr, p1, p2)) {
      temp[++tn] = arr[p1++]
    } else {
      temp[++tn] = arr[p2++]
    }
  }

  # phase 2: replace array from left to right by temp
  for (i = 1; i <= tn; i++) {
    arr[left - 1 + i] = temp[i]
  }
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
    # label section with name new
    # new:
      push(stack_new(left, right, "merge"))
      push(stack_new(mid + 1, right, "new"))
      push(stack_new(left, mid, "new"))
    } else if (state == "merge") {
    # label section with name merge
    # merge:
      merge(arr, left, mid, right)
    }

  }

}

function node_merge(n1, n2) {
  nid = node_new("", freq[n1] + freq[n2], n1, n2, node_le(n1, n2) ? leftmost[n1] : leftmost[n2])
  return nid
}

function fetch_queue(q1, q2, qid1, qid2) {
  if (is_empty(qid1)) return dequeue(q2, qid2)
  if (is_empty(qid2)) return dequeue(q1, qid1)
  if (node_le(q1[start[qid1]], q2[start[qid2]])) {
    return dequeue(q1, qid1)
  } else {
    return dequeue(q2, qid2)
  }
}

function build_converter(nid, prefix) {
  if (left[nid] == 0 && right[nid] == 0) {
    encoder[char[nid]] = prefix
    decoder[prefix] = char[nid]
    return
  }
  if (left[nid]) build_converter(left[nid], prefix "0")
  if (right[nid]) build_converter(right[nid], prefix "1")
}

function encode(str,   enc, i) {
  for (i = 1; i <= length(str); i++) {
    enc = enc encoder[substr(str, i, 1)]
  }
  return enc
}

function decode(enc,   code, text, i) {
  code = ""; text = ""
  for (i = 1; i <= length(enc); i++) {
    code = code substr(enc, i, 1)
    if (code in decoder) {
      text = text decoder[code]
      code = ""
    }
  }
  return text
}

# function print_node(nid) {
#   printf "(%s)<%s,%s,%s,%s,%s>", nid, char[nid], freq[nid], left[nid], right[nid], leftmost[nid]
# }
# 
# function print_queue(q, qid,   i) {
#   if (is_empty(qid)) {
#     print "[]"
#     return
#   }
#   printf "["
#   for (i = start[qid]; i <= end[qid]; i++) {
#     printf i == end[qid] ? print_node(q[i]) "]\n" : print_node(q[i]) ", "
#   }
# }
# 
# function print_encoder(   ch) {
#   for (ch in encoder) {
#     print ch, encoder[ch]
#   }
# }
# 
# function print_decoder(   code) {
#   for (code in decoder) {
#     print code, decoder[code]
#   }
# }


NR == 1 {
  n = length($0)
  for (i = 1; i <= n; i++) {
    counter[substr($0, i, 1)]++
  }

  char_n = length(counter)
  delete q1; delete q2; QID1 = 1; QID2 = 2

  for (ch in counter) {
    enqueue(q1, QID1, node_new(ch, counter[ch]))
  }

  merge_sort(q1, start[QID1], end[QID1])

  # q1: queue of initial nodes, sorted
  # q2: queue of internal nodes

  # build root
  for (i = char_n; i >= 2; i--) {
    nid1 = fetch_queue(q1, q2, QID1, QID2)
    nid2 = fetch_queue(q1, q2, QID1, QID2)
    enqueue(q2, QID2, node_merge(nid1, nid2))
  }

  root = q2[start[QID2]]
  build_converter(root, "")

  enc = encode($0)
  printf "enc: %s\n", enc
  text = decode(enc)
  printf "text: %s\n", text

}
