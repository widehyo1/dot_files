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
      key = FILENAME SUBSEP ln SUBSEP line
      if (!(key in seen)) {
        print FILENAME, ln, line
        seen[key]
      }
    }
  }

  # 매칭 라인
  key = FILENAME SUBSEP FNR SUBSEP $0
  if (!(key in seen)) {
    print FILENAME, FNR, $0
    seen[key]
  }

  after = 10
  next
}

after > 0 {
  key = FILENAME SUBSEP FNR SUBSEP $0
  if (!(key in seen)) {
    print FILENAME, FNR, $0
    seen[key]
  }
  after--
}
