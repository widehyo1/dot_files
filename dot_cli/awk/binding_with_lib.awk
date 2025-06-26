@include "common"
@include "functool"


function sample(a, b, c) {
  printf "a: %s, b: %s, c: %s\n", a, b, c
}

BEGIN {
  SSEP = "\035"
  split("a b c", arginfo)
  saveSignature("sample", arginfo)
  split("b c", keys)
  split("5678 asdf", vals)
  zip(keys, vals, bindings)
  bind("partial", "sample", bindings)
  split("1", args)
  call("partial", args)
}


