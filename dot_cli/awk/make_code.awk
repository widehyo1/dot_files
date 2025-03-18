function strip(str) {
    gsub(/^\s+|\s+$/, "", str)
    return str
}

BEGIN {
    RS = ""
}
NR == 1{
    split($0, lines, "\n")
    for (idx in lines) {
        lines[idx] = strip(lines[idx])
        declare[idx] = lines[idx]
    }
}
NR == 2{
    split($0, lines, "\n")
    for (idx in lines) {
        lines[idx] = strip(lines[idx])
    }
    for (idx in lines) {
        split(lines[idx], info_arr, ",")
        info_arr[5] = strip(info_arr[5])
        comment[idx] = substr(info_arr[5], 4)
    }
}
NR == 3{

    for (idx in declare) {
        print declare[idx]
        print "    '''"
        print "    " comment[idx], "생성 프로세서"
        print "    '''"
        print $0
        print "\n\n"
    }
}
