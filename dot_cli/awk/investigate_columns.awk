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
    print length(meta_arr)

}
/Table/{
    split($0, arr, /\s+/)
    gsub(/"/, "", arr[3])
    meta_arr[++table_count] = arr[3]
    col_info_arr[meta_arr[table_count]] = ""
    # print "\n" strip($0) "\n"
}
NF == 9 && !/Column/{
    # print $1
    col_info_arr[meta_arr[table_count]] = col_info_arr[meta_arr[table_count]] "," strip($1) 
}
END {
    # for (idx in meta_arr) {
    #     print "idx:",idx,"meta_arr[idx]:",meta_arr[idx]
    # }
    # for (idx in col_info_arr) {
    #     print "idx:",idx,"col_info_arr[idx]:",col_info_arr[idx]
    # }
    for (idx in col_info_arr) {
        print idx ": " col_info_arr[idx]
    }

}

