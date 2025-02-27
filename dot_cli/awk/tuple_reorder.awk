function surround_str(str, start, end) {
    return start str end
}

BEGIN {
    FS = ","
    OFS = ","
}
{
    gsub(/^\s+\(/, "", $0)
    gsub(/\),\s+$/, "", $0)
    target = $3 "," $2 "," $1
    print surround_str(target, "(", "),")
}


