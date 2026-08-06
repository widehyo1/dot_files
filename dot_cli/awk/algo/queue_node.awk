# queue_node.awk
#
# struct {
#   field1: int
#   field2: int
# } queue_node
#
# with id: qnid

function enqueue(qnid) {
  queue[++back] = qnid
  if (!front) front = back
}

function dequeue(   qnid) {
  if (!front) return ""
  if (back < front) return ""
  qnid = queue[front]
  delete queue[front++]
  return qnid
}

function peek() {
  if (!front) return ""
  return queue[front]
}

function queue_new(field1, field2) {
  _qnid++
  queue[_qnid, "field1"] = field1
  queue[_qnid, "field2"] = field2
  return _qnid
}

function print_node(qnid) {
  printf "< queue node (%s, %s) >\n", queue[qnid, "field1"], queue[qnid, "field2"]
}

function print_queue() {
  for (i = front; i <= back; i++) {
    print_node(queue[i])
  }
}

/PUSH/ { enqueue(queue_new($2, $3)) }

END {
  print "queue"
  print_queue()

  print "dequeue"
  while (qnid = dequeue()) {
    print_node(qnid)
  }

}
