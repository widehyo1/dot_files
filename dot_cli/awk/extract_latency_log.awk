substr($0, 80, 20) ~ /LatencyLoggingFilter/ {
  print substr($0, 104)
}
