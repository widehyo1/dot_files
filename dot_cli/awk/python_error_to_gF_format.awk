BEGIN {
    FS = "\""
}
{
    split($3, arr, /\s+/)
    print $2 ":" arr[3]
}

