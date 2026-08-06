# queue.awk

function enqueue(val) {
  queue[++back] = val
  if (!front) front = back
}

function dequeue(   res) {
  if (!front) return ""
  if (back < front) return ""
  res = queue[front]
  delete queue[front++]
  return res
}

function print_queue() {
  print_fb()
  for (i = front; i <= back; i++) {
    print queue[i]
  }
}

function print_fb() {
  printf "%s..%s\n", front, back
}

function from(arr) {
  for (i = 1; i <= length(arr); i++) {
    enqueue(arr[i])
  }
}

{
  split($0, arr)
  from(arr)
  print_queue()

  print "deque:"
  while (res = dequeue()) {
    print res
    print_fb()
  }

}
