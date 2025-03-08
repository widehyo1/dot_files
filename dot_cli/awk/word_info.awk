function strip(str) {
    gsub(/^\s+|\s+$/, "", str)
    return str
}

BEGIN {
    RS = ""
    FS = ":"
}
NR == 1{
    print NR
    split($0, lines, "\n")
    for (idx in lines) {
        lines[idx] = strip(lines[idx])
    }
    for (idx in lines) {
        split(lines[idx], arr, ":")
        left_key = strip(arr[1])
        left_word[left_key] = -1
    }
    for (idx in left_word) {
        print idx, left_word[idx]
    }
}
NR == 2{
    print NR
    split($0, lines, "\n")
    for (idx in lines) {
        lines[idx] = strip(lines[idx])
    }
    for (idx in lines) {
        split(lines[idx], arr, ":")
        right_key = strip(arr[1])
        right_word[right_key] = 1
        is_contain_type = match(arr[2], /\[([^]]+)\]/, type_arr)
        if (is_contain_type) {
            field_type = type_arr[1]
            right_type[right_key] = field_type
        }
    }
    for (idx in right_word) {
        print idx, right_word[idx]
    }
}
END {
    print "\nword info:\n"
    for (idx in left_word) {
        word_info[idx] += left_word[idx]
    }
    for (idx in right_word) {
        word_info[idx] += right_word[idx]
    }
    for (idx in word_info) {
        if (word_info[idx] == 1) {
            # print idx, word_info[idx]
            print idx " : Optional[" right_type[idx] "]"
        }
    }
}

