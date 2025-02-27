function surround_str(str, start, end) {
    return start str end
}

function strip(str) {
    gsub(/^\s+|\s+$/, "", str)
    return str
}

function join(arr, sep) {
    acc = arr[1]
    for (i = 2; i <= length(arr); i++) {
        acc = acc sep arr[i]
    }
    return acc
}

{
    split($0, arr, /: /)
    gsub(/idp.fv_/, "", arr[1])
    split(arr[2], column_arr, /,/)
    printf arr[1] "_field = "
    for (idx in column_arr) {
        column_arr[idx] = surround_str(strip(column_arr[idx]), "'", "'")
    }
    print surround_str(join(column_arr, ","), "[", "]")
}
