{
    buf[NR % 21] = $0
}
$0 ~ /2-111/ || $0 ~ /2-103/ || $0 ~ /2-147/{
    for (i = 1; i <= 10; i++)
        print FILENAME, FNR, buf[(NR - i) % 21]
    print $0
    after = 10
    next
}
after > 0 {
    print FILENAME, FNR, $0
    after--
}
