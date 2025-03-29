NR >= 2 && NR <= 8{
    split($4, arr, "<")
    term = substr(arr[1], 7)
    abbrterm = substr($2, 8)
    print $1, $2, $3, $4
    print $1, "<space>a" abbrterm, $3, "Surrond" term "<CR>"
    print $1, "<space>d" abbrterm, $3, "UnSurrond" term "<CR>"
}
