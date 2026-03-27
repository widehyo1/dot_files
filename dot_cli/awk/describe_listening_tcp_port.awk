NR > 1 { arr[$2] }
END {
  for (pid in arr) {
    printf "echo '=== pid(%s) ==='\n", pid
    print "echo [cwd]"
    printf "sudo readlink -f /proc/%s/cwd\n", pid
    print "echo [cmdline]"
    printf "cat /proc/%s/cmdline | tr '\\0' '\\n'\n", pid
    pids = pids "," pid
  }
  pids = substr(pids, 2)
  printf "ps -fp %s\n", pids
}
