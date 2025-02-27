BEGIN {
    FS = "\""
    OFS = "\""
    comment_str = "주관부서,예산,기대효과,홍보채널"
    split(comment_str, comment_arr, ",")
    name_str = "department_name,budget,expected_effect,information_channel"
    split(name_str, name_arr, ",")
}
{
    gsub(/location_name/, name_arr[NR], $1)
    print $1, comment_arr[NR], $3
}
