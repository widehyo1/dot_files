@include "extension"

# out array set to res
function map(arr, fn, res,     idx) {
  delete res
  for (idx in arr) {
    res[idx] = @fn(arr[idx])
  }
}

# inplace operation
function apply(arr, fn,     idx) {
  for (idx in arr) {
    arr[idx] = @fn(arr[idx])
  }
}

function filter(arr, pred, res,    count, i) {
  delete res
  for (i = 1; i <= length(arr); i++) {
    if (@pred(arr[i])) res[++count] = arr[i]
  }
}

function filterAssoc(arr, pred, res,     idx) {
  delete res
  for (idx in arr) {
    if (@pred(arr[idx])) res[idx] = arr[idx]
  }
}

# save binding arguments to global variable FREEVARS
# key will be used as partial function(default parameter from binding info)
# the form value consists two parts, head and tails separated with first SSEP
# head contains `original function name`
# tail is of form string representation of the list of tuple, which argName SUBSEP value
# each elements is joined with SSEP
function bind(key, fnname, freeVars,    argRepr) {
  if (! SSEP) SSEP = "\035"
  argRepr = fnname SSEP

  if (length(freeVars) == 0) {
    FREEVARS[key] = argRepr
    return
  }
  argRepr = argRepr serializeAssoc(freeVars)
  FREEVARS[key] = argRepr
}

function serializeAssoc(assoc,    acc) {
  assert(SSEP, "SSEP is not set")
  for (key in assoc) {
    acc = acc key SUBSEP assoc[key] SSEP
  }
  return substr(acc, 1, length(acc) - 1)
}

function bindPosition(array,    acc) {
  assert(SSEP, "SSEP is not set")
  for (i = 1; i <= length(array); i++) {
    acc = acc i SUBSEP array[i] SSEP
  }
  return substr(acc, 1, length(acc) - 1)
}

function strReprArr2dict(strReprArr, dict,    strRepr) {
  delete dict
  for (i = 1; i <= length(strReprArr); i++) {
    strRepr = strReprArr[i]
    dict[substr(strRepr, 1, index(strRepr, SUBSEP) - 1)] = substr(strRepr, index(strRepr, SUBSEP) + 1) # dict[key] = val
  }
}

function call(key, args,    bindings) {
  if (! SSEP) SSEP = "\035"
  if (!FREEVARS[key]) {
    print "unregistered function call"
    return
  }
  buildParameter(key, args, params)

  switch (length(params)) {
    case 1:
      @fnname(params[1])
      break
    case 2:
      @fnname(params[1], params[2])
      break
    case 3:
      @fnname(params[1], params[2], params[3])
      break
    case 4:
      @fnname(params[1], params[2], params[3], params[4])
      break
    default:
      print "#(function params) must one of 1, 2, 3, or 4"
      return
  }

}

function buildParameter(key, args, params) {
  assert(SSEP, "SSEP is not set")
  delete params
  fnname = substr(FREEVARS[key], 1, index(FREEVARS[key], SSEP) - 1)
  inspectParams(fnname, paramDict)
  bindingRepr = substr(FREEVARS[key], index(FREEVARS[key], SSEP) + 1)
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
  assert(SSEP, "SSEP is not set")
  delete bindingDict
  split(repr, tmp, SSEP)
  for (idx in tmp) {
    bindingDict[substr(tmp[idx], 1, index(tmp[idx], SUBSEP) - 1)] = substr(tmp[idx], index(tmp[idx], SUBSEP) + 1)
  }
}

function inspectParams(fnname, paramDict) {
  posRepr = FUNCSIG[fnname]
  posRepr2Dict(posRepr, paramDict)
}

function posRepr2Dict(posRepr, paramDict,    tmp, posNameTuple) {
  assert(SSEP, "SSEP is not set")
  delete paramDict
  split(posRepr, tmp, SSEP)
  for (idx in tmp) {
    split(tmp[idx], posName, SUBSEP)
    paramDict[posName[2]] = posName[1]
  }
}

# save function signature to global variable FUNCSIG
# argument information is of form list of tuples (position, parameter name)
# list element delemter: SSEP, key-value delemeter: SUBSEP
function saveSignature(fnname, argInfo) {
  if (! SSEP) SSEP = "\035"
  posRepr = bindPosition(argInfo)
  FUNCSIG[fnname] = posRepr
}
