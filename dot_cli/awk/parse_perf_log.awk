function field_value(k,    i, a) {
  for (i = 1; i <= NF; i++) {
    split($i, a, "=")
    if (a[1] == k) return a[2]
  }
  return ""
}

function is_ms_field(k) {
  return k ~ /_ms$/
}

/phase=/ {
  phase = field_value("phase")
  if (phase == "") next

  for (i = 1; i <= NF; i++) {
    split($i, a, "=")
    key = a[1]
    value = a[2]

    if (is_ms_field(key) && value ~ /^[0-9.]+$/) {
      ms[phase, key] += value
      phase_total[phase] += value
      total_ms += value
      phases[phase] = 1
      fields[phase, key] = 1
    }
  }
}

END {
  print "phase별 ms 합계"
  print "----------------"

  for (phase in phases) {
    printf "%s\t%.3fs\t%.0fms", phase, phase_total[phase] / 1000, phase_total[phase]

    if (total_ms > 0) {
      printf "\t~%.0f%%", 100 * phase_total[phase] / total_ms
    }

    print ""
  }

  print ""
  print "세부작업별 ms 합계"
  print "----------------"

  for (k in fields) {
    split(k, parts, SUBSEP)
    phase = parts[1]
    field = parts[2]

    printf "%s.%s\t%.3fs\t%.0fms", phase, field, ms[phase, field] / 1000, ms[phase, field]

    if (total_ms > 0) {
      printf "\t~%.0f%%", 100 * ms[phase, field] / total_ms
    }

    print ""
  }

  print ""
  printf "measured total\t%.3fs\t%.0fms\n", total_ms / 1000, total_ms
}
