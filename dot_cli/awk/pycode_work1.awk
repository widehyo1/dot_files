BEGIN {
    FS = ","
}
{
    for (i = 1; i <= NF; i++) {
        print $i "_seq_max = max([data[0] for data in " $i "_data]) + 1"
    }
}
