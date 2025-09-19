map(
  .latency as $l
  | $l.pattern
  | gsub("{(?<c>[^}]+)}"; "\($l.vars[.c])") as $p
  | { pattern: $l.pattern, actual_pattern: $p, elapsedMs: $l.elapsedMs }
)
| group_by(.pattern, .actual_pattern, .elapsedMs)
| map({
    pattern: .[0].pattern,
    actual_pattern: .[0].actual_pattern,
    elapsedMs: .[0].elapsedMs,
    count: length
})
| group_by(.pattern)
| map({
    pattern: .[0].pattern,
    actual_patterns: (
      group_by(.actual_pattern)
      | map({
          actual_pattern: .[0].actual_pattern,
          buckets: (
            group_by(.elapsedMs)
            | map({
                elapsedMs: .[0].elapsedMs,
                count: (map(.count) | add)
              })
          )
        })
    )
})
