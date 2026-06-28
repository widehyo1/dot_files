function trim_tree_line(line,    x) {
  x = line

  # leading tree glyph / indent 제거
  # 예:
  # ./
  # ├─ Cargo.toml
  # │  ├─ swb-core/
  # └─ tests/
  sub(/^[[:space:]]*\.[\/]?$/, "", x)
  gsub(/^[[:space:]│]*[├└]─[[:space:]]*/, "", x)

  return x
}

function depth_of(line,    s, n) {
  s = line
  n = 0

  # tree indent unit:
  # "│  " 또는 "   " 단위가 depth 1
  while (match(s, /^[[:space:]│]{3}/)) {
    n++
    s = substr(s, 4)
  }

  return n
}

{
  raw = $0

  # root line "./" skip
  if (raw ~ /^[[:space:]]*\.[\/]?[[:space:]]*$/) {
    next
  }

  item = trim_tree_line(raw)

  if (item == "") {
    next
  }

  depth = depth_of(raw)

  # 현재 depth보다 깊은 stack 제거
  for (i in path) {
    if (i >= depth) {
      delete path[i]
    }
  }

  is_dir = (item ~ /\/$/)
  gsub(/\/$/, "", item)

  path[depth] = item

  full = ""
  for (i = 0; i <= depth; i++) {
    if (i in path) {
      full = (full == "" ? path[i] : full "/" path[i])
    }
  }

  if (is_dir) {
    print "mkdir -p " q full q
  } else {
    parent = full
    sub(/\/[^\/]+$/, "", parent)

    if (parent != full) {
      print "mkdir -p " q parent q
    }
    print "touch " q full q
  }
}
BEGIN {
  q = sprintf("%c", 39)
}
