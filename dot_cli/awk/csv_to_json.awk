function transform(arr, out_arr) {
    count = 1
    for (key in arr) {
        out_arr[count] = key ":" arr[key]
        count++
    }
}
function join(arr, sep) {
    acc = arr[1]
    for (i = 2; i <= length(arr); i++) {
        acc = acc sep arr[i]
    }
    return acc
}
BEGIN {
    cmd = "wc -l < " ARGV[1]
    cmd | getline num_lines
    close(cmd)
    FS = ","
    print "["
}
NR == 1 {
    split($0, header_arr, FS)
    for (idx in header_arr) {
        header_arr[idx] = "\"" header_arr[idx] "\""
    }
}
NR > 1 {
    for (idx in header_arr) {
        res[NR][header_arr[idx]] = $idx
    }
    res[NR][header_arr[2]] = "\"" $2 "\""
    res[NR][header_arr[3]] = "\"" $3 "\""
    res[NR][header_arr[4]] = "\"" $4 "\""
}
END {
    for (idx in res) {
        transform(res[idx], out_res)
        cur = join(out_res, ",")
        if (idx != num_lines) {
            print "    {" cur "},"
        } else {
            print "    {" cur "}"
        }
    }
    print "]"
}
