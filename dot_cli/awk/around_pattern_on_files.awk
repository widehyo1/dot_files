BEGIN {
  OFS = "|"
}

{
  buf[NR % 21] = $0
}

/2-111|2-103|2-147/ {
  # 앞 10줄
  for (i = 10; i >= 1; i--) {
    ln = FNR - i
    if (ln > 0) {
      line = buf[(NR - i + 21) % 21]
      if (!seen[FILENAME,ln,line]++)
        print FILENAME, ln, line
    }
  }

  # 매칭 라인
  if (!seen[FILENAME,FNR,$0]++)
    print FILENAME, FNR, $0
  after = 10
  next
}

after > 0 {
  if (!seen[FILENAME,FNR,$0]++)
    print FILENAME, FNR, $0
  after--
}
