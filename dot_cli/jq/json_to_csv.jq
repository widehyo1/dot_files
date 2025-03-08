(first | keys) as $keys |
($keys | @csv), ( map([.[]]) | map(@csv)[])
