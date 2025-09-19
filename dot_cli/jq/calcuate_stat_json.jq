group_by(.pattern)
| map({
    pattern: .[0].pattern,
    actual_patterns: (
      group_by(.actual_pattern)
      | map({
          actual_pattern: .[0].actual_patterns[0].actual_pattern,
          total_count: (map(.actual_patterns[0].buckets[] | .count) | add),
          stats: (
            # 샘플 리스트로 확장
            (map(.actual_patterns[0].buckets[] as $b | [range($b.count)] | map($b.elapsedMs)) | add) as $samples
            | {
                mean: ($samples | add / length),
                min: ($samples | min),
                max: ($samples | max),
                p50: ($samples | sort | .[(length*0.50|floor)]),
                p95: ($samples | sort | .[(length*0.95|floor)]),
                p99: ($samples | sort | .[(length*0.99|floor)])
              }
          )
        })
    )
})
