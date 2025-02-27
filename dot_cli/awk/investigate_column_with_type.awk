function strip(str) {
    gsub(/^\s+|\s+$/, "", str)
    return str
}
BEGIN {
    FS = "|"
    table_count = 0
    split("", meta_arr, "")
    for (idx in meta_arr) {
        print "idx:",idx,"meta_arr[idx]:",meta_arr[idx]
    }
}
/Table/{
    col_count = 0
    split($0, arr, /\s+/)
    gsub(/"/, "", arr[3])
    meta_arr[++table_count] = arr[3]
    split("", table_arr, "")
}
NF == 9 && !/Column/{
    # print $1
    col_count++
    key = meta_arr[table_count]
    table_arr[col_count] = strip($1) ":" strip($2)
    for (idx in table_arr) {
        col_info_arr[key, col_count] = table_arr[col_count]
    }
}
END {
    for (index_ in col_info_arr) {
        split(index_, key_arr, SUBSEP)
        print "["key_arr[1]"("key_arr[2]")]"col_info_arr[index_]
    }
}
