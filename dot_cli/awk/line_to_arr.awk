function strip(str) {
    gsub(/^\s+|\s+$/, "", str)
    return str
}

BEGIN {
    FS = "|"
}
{
    arr[NR] = strip($1)
}
END {
    for (idx in arr) {
        print "idx:",idx,"arr[idx]:",arr[idx]
    }
}

