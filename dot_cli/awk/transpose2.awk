{
  for (i = 1; i <= NF; i++) {
    a[NR, i] = $i
    if (i > max_nf) max_nf = i
  }
}
END {
  for (i = 1; i <= max_nf; i++) {
    for (j = 1; j <= NR; j++) {
      printf "%s%s", a[j, i], (j < NR ? OFS : ORS)
    }
  }
}
