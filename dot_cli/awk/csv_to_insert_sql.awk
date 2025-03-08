function join(arr, sep) {
    acc = arr[1]
    for (i = 2; i <= length(arr); i++) {
        acc = acc sep arr[i]
    }
    return acc
}
function strip(str) {
    gsub(/^\s+|\s+$/, "", str)
    return str
}
function surround_str(str, start, end) {
    return start str end
}
function apply_strip(format_arr) {
    for (idx in format_arr) {
        format_arr[idx] = strip($idx)
    }
}
function transform_header(header_str) {
    split(header_str, header_arr, ",")
    for (idx in header_arr) {
        header_arr[idx] = surround_str(header_arr[idx], "`", "`")
    }
    result = join(header_arr, ",")
    return result
}
function transform_content(content_str) {
    split(content_str, content_arr, ",")
    apply_strip(content_arr)
    content_arr[2] = surround_str(content_arr[2], "'", "'")
    content_arr[3] = surround_str(content_arr[3], "'", "'")
    content_arr[4] = surround_str(content_arr[4], "'", "'")
    result = join(content_arr, ",")
    return result
}
BEGIN {
    cmd = "wc -l < " ARGV[1]
    cmd | getline num_lines
    close(cmd)
    FS = ","
    OFS = ","
    header_format_str = "연번,행정동,관리단체,설치장소(도로명주소),위도,경도"
    content_format_str = "1,광평동,대한민국특수임무유공자회,구미시 구미대로 14길 7-5,36.107064,128.364115"
}
NR == 1 {
    header = ""
    insert_str = transform_header(header_format_str)
    print "INSERT INTO my_table(" insert_str ") VALUES"
}
NR > 1 && NR < num_lines {
    row_str = transform_content(content_format_str)
    print "(" row_str "),"
}
NR == num_lines {
    row_str = transform_content(content_format_str)
    print "(" row_str ");"
}
