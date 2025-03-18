`p1.awk`
```awk
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
    }
    for (idx in lines) {
        if (idx == 1) continue
        split(lines[idx], arr, ",")
        print arr[3]
    }
}
```

`p2.awk`
```awk
function strip(str) {
    gsub(/^\s+|\s+$/, "", str)
    return str
}

BEGIN {
    RS = ""
}
NR == 2{
    split($0, lines, "\n")
    for (idx in lines) {
        lines[idx] = strip(lines[idx])
    }
    for (idx in lines) {
        if (idx == 1) continue
        split(lines[idx], arr, ",")
        print arr[3]
    }
}
```

```bash
33950  2025-03-17_08:46:02 awk -f p1.awk ~/temp.txt
33951  2025-03-17_08:46:11 awk -f p1.awk ~/temp.txt  | sort | uniq
33952  2025-03-17_08:46:27 awk -f p1.awk ~/temp.txt  | sort | uniq > uniq_amddong.txt
33954  2025-03-17_08:47:27 awk -f p2.awk ~/temp.txt
33955  2025-03-17_08:47:37 awk -f p2.awk ~/temp.txt  | sort | uniq
33956  2025-03-17_08:47:54 awk -f p2.awk ~/temp.txt  | sort | uniq > fv_address_unique.txt
```
