function sample(a, b, c) {
  printf "a: %s, b: %s, c: %s\n", a, b, c
}

# save binding arguments to global variable BINDING
# key will be used as partial function(default parameter from binding info)
# the form value consists two parts, head and tails separated with first SSEP
# head contains `original function name`
# tail is of form string representation of the list of tuple, which argName SUBSEP value
# each elements is joined with SSEP
function bind(key, fnname, bindings,    argRepr) {
  argRepr = fnname SSEP

  if (length(bindings) == 0) {
    BINDING[key] = argRepr
    return
  }
  argRepr = argRepr serializeAssoc(bindings)
  BINDING[key] = argRepr
}

function serializeAssoc(assoc,    acc) {
  for (key in assoc) {
    acc = acc key SUBSEP assoc[key] SSEP
  }
  return substr(acc, 1, length(acc) - 1)
}

function bindPosition(array,    acc) {
  for (i = 1; i <= length(array); i++) {
    acc = acc i SUBSEP array[i] SSEP
  }
  return substr(acc, 1, length(acc) - 1)
}

function flip(assoc) {
  for (idx in assoc) {
    assoc[assoc[idx]] = idx
  }
}

function printArray(arr, arrName) {
  for (idx in arr) {
    printf "%s[%s]: %s\n", (arrName ? arrName : "arr"), idx, arr[idx]
  }
}

function apply(arr, fn) {
  for (idx in arr) {
    arr[idx] = @fn(arr[idx])
  }
}

function strReprArr2dict(strReprArr, dict,    strRepr) {
  delete dict
  for (i = 1; i <= length(strReprArr); i++) {
    strRepr = strReprArr[i]
    partition(strRepr, SUBSEP, headtail)
    dict[headtail[1]] = headtail[2]
  }
}

function partition(str, sep, headtail) {
  headtail[1] = substr(str, 1, index(str, sep) - length(sep))
  headtail[2] = substr(str, index(str, sep) + length(sep))
}

function call(key, args,    bindings) {
  if (!BINDING[key]) {
    print "unregistered function call"
    return
  }
  buildParameter(key, args, params)

  switch (length(params)) {
    case 1:
      executeFunc1(fnname, params)
      break
    case 2:
      executeFunc2(fnname, params)
      break
    case 3:
      executeFunc3(fnname, params)
      break
    case 4:
      executeFunc4(fnname, params)
      break
    default:
      print "#(function params) must one of 1, 2, 3, or 4"
      return
  }

}

function buildParameter(key, args, params) {
  partition(BINDING[key], SSEP, fnBinding)
  fnname = fnBinding[1]
  inspectParams(fnname, paramDict)
  bindingRepr = fnBinding[2]
  bindingRepr2Dict(bindingRepr, bindingDict)

  for (idx in args) {
    params[idx] = args[idx]
  }
  for (idx in paramDict) {
    if (!params[paramDict[idx]]) {
      params[paramDict[idx]] = bindingDict[idx]
    }
  }
  if (length(paramDict) != length(params)) {
    print "invalid execution, mismatch between original function and binded function"
    delete params
  }
}

function bindingRepr2Dict(repr, bindingDict,    tmp) {
  split(repr, tmp, SSEP)
  for (idx in tmp) {
    split(tmp[idx], keyVal, SUBSEP)
    bindingDict[keyVal[1]] = keyVal[2]
  }
}

function inspectParams(fnname, paramDict) {
  posRepr = FUNCSIG[fnname]
  posRepr2Dict(posRepr, paramDict)
}

function posRepr2Dict(posRepr, paramDict,    tmp, posNameTuple) {
  split(posRepr, tmp, SSEP)
  for (idx in tmp) {
    split(tmp[idx], posName, SUBSEP)
    paramDict[posName[2]] = posName[1]
  }
}

function executeFunc1(fnname, params) {
  @fnname(params[1])
}

function executeFunc2(fnname, params) {
  @fnname(params[1], params[2])
}

function executeFunc3(fnname, params) {
  @fnname(params[1], params[2], params[3])
}

function executeFunc4(fnname, params) {
  @fnname(params[1], params[2], params[3], params[4])
}

# save function signature to global variable FUNCSIG
# argument information is of form list of tuples (position, parameter name)
# list element delemter: SSEP, key-value delemeter: SUBSEP
function saveSignature(fnname, argInfo) {
  posRepr = bindPosition(argInfo)
  FUNCSIG[fnname] = posRepr
}

function zip(arr1, arr2, dict) {
  minlen = (length(arr1) < length(arr2) ? length(arr1) : length(arr2))
  for (i = 1; i <= minlen; i++) {
    dict[arr1[i]] = arr2[i]
  }
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
