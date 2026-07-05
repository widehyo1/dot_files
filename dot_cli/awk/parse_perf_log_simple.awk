function val(k,    i, a) {
  for (i = 1; i <= NF; i++) {
    split($i, a, "=")
    if (a[1] == k) return a[2] + 0
  }
  return 0
}

/phase=scan.chunk/ {
  parse_ms += val("parse_ms")
  walk_ms  += val("walk_ms")
}

/phase=sqlite.flush\./ {
  flush_ms += val("elapsed_ms")
}

/phase=sqlite.prune.object_priority/ {
  object_prune_ms += val("elapsed_ms")
}

/phase=sqlite.prune.value_priority/ {
  value_prune_ms += val("elapsed_ms")
}

/^\[perf\] total=/ {
  total_s = $2
  sub(/^total=/, "", total_s)
  sub(/s$/, "", total_s)
  total_s += 0
}

END {
  prune_ms = object_prune_ms + value_prune_ms

  printf "scan.chunk walk_ms\t%.3fs\n", walk_ms / 1000
  printf "scan.chunk parse_ms\t%.3fs\n", parse_ms / 1000
  printf "SQLite flush 전체\t%.3fs\n", flush_ms / 1000
  printf "SQLite prune 전체\t%.3fs\n", prune_ms / 1000
  printf "sqlite.prune.value_priority\t%.3fs\n", value_prune_ms / 1000
  printf "sqlite.prune.object_priority\t%.3fs\n", object_prune_ms / 1000

  print ""

  printf "walk:\t\t~%.0f%%\n", 100 * (walk_ms / 1000) / total_s
  printf "SQLite prune:\t~%.0f%%\n", 100 * (prune_ms / 1000) / total_s
  printf "SQLite flush:\t~%.0f%%\n", 100 * (flush_ms / 1000) / total_s
  printf "parse:\t\t~%.0f%%\n", 100 * (parse_ms / 1000) / total_s
}
