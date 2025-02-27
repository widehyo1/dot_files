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
function surround_str(str, start, end) {
    return start str end
}
BEGIN {
    FS = "|"
}
{
    arr[NR] = strip($1)
}
END {
    print surround_str(join(arr, ","), "(", ")")
}

