function build_servers() {
  for (i = 2; i <= NF; i++) {
    split($i, arr, " ")
    servers[arr[1]] = arr[2]
  }
  delete arr
}
function build_partitions() {
  for (i = 2; i <= NF; i++) {
    split($i, arr, " ")
    partitions[arr[1]] = arr[2]
  }
  delete arr
}
function print_command() {

  for (i = 2; i <= NF; i++) {
    split($i, arr, " ")

    ip = servers[arr[1]]
    path = partitions[arr[2]]

    cmd = sprintf("ssh bigdata@%s 'sudo LC_ALL=C find -P %s -xdev -name \".*\" ! -name . -prune -o -printf ", ip, path)
    cmd = cmd "\"%P\\0%y\\0%s\\0%b\\0%M\\0%n\\0%U\\0%G\\0%T@\\0%l\\0\"'"
    cmd = cmd " | ls-lr-analyzer export --input-format find --format parquet --output "
    fname = sprintf("snapshots/%s-%s-%s.parquet", today, arr[1], arr[2])
    cmd = cmd fname " -"

    print cmd
  }
  delete arr
}
BEGIN {
  RS=""
  FS="\n"
  today = strftime("%Y%m%d")
}
{
  if ($1 == "[servers]") build_servers()
  if ($1 == "[partitions]") build_partitions()
  if ($1 == "[data]") print_command()
}
