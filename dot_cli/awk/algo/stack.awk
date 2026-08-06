# stack.awk

function push(val) {
  stack[++stack_n] = val
}

function pop(   val) {
  if (!stack_n) return ""
  val = stack[stack_n]
  delete stack[stack_n--]
  return val
}

function peek() {
  return stack[stack_n]
}

function from(arr) {
  for (i = 1; i <= length(arr); i++) {
    push(arr[i])
  }
}

function print_stack() {
  printf "stack "
  for (i = 1; i <= stack_n; i++) {
    repr = i == stack_n ? stack[i] : stack[i] ","
    printf repr
  }
  print ""
}

{
  split($0, arr)
  from(arr)
  print_stack()
}
