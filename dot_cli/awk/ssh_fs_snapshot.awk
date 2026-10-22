function build_servers() {
  servers[$1] = $2
}
function build_partitions() {
  partitions[$1] = $2
}
function print_command() {
  ip = servers[$1]
  path = partitions[$2]

  cmd = sprintf("ssh -n bigdata@%s 'sudo LC_ALL=C find -P %s -xdev -name \".*\" ! -name . -prune -o -printf ", ip, path)
  cmd = cmd "\"%P\\0%y\\0%s\\0%b\\0%M\\0%n\\0%U\\0%G\\0%T@\\0%l\\0\"'"
  cmd = cmd " | ls-lr-analyzer export --input-format find --format parquet --output "
  fname = sprintf("snapshots/%s-%s-%s.parquet", today, $1, $2)
  cmd = cmd fname " -"

  print cmd
}

BEGIN {
  today = strftime("%Y%m%d")
}

/SECTION/ { section = $2; next }
length == 0 { next }
section == "servers" { build_servers() }
section == "partitions" { build_partitions() }
section == "data" { print_command() }
