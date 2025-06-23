# out array set to global variable "mapres"
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

