BEGIN {
    FS = ","
}
{
    $4 = "'" $4 "'"
    $5 = "'" $5 "'"
    $7 = "'" $7 "'"
    $8 = "True"
    printf ",("
    for (i = 1; i <= NF; i++) {
        printf $i ","
    }
    printf ")\n"
}
