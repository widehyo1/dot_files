# stack_node.awk
#
# struct {
#   field1: int,
#   field2: int
# } node
#
# with id: _nid

function push(nid) {
  stack[++stack_n] = nid
}

function pop(   nid) {
  if (!stack_n) return ""
  nid = stack[stack_n]
  delete stack[stack_n--]
  return nid
}


function node_new(field1, field2) {
  _nid++
  node[_nid, "field1"] = field1
  node[_nid, "field2"] = field2
  return _nid
}

function print_node(nid) {
  printf "< node(%s, %s) >\n", node[nid, "field1"], node[nid, "field2"]
}

function print_stack() {
  print "stack:"
  for (i = 1; i <= stack_n; i++) {
    print_node(stack[i])
  }
}

/PUSH/ { push(node_new($2, $3)) }

END {
  print_stack()

  print "pop:"
  while (stack_n) {
    print_node(pop())
  }
}
