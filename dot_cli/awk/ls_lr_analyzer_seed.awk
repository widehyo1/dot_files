function make_snapshot_command(partition_root) {
  return sprintf(template, partition_root) find_template
}

function make_fname(server_name, partition_name) {
  return sprintf("find_snapshot_%s_%s_%s.find", strftime("%Y%m%d"), server_name, partition_name)
}

function make_ssh_command(host_seed, partition_root,   parts, cmd) {
  delete parts
  split(host_seed, parts)
  cmd = sprintf("ssh root@127.0.0.%s \"", parts[1])
  cmd = cmd make_snapshot_command(partition_root) "\" > "
  cmd = cmd make_fname(parts[2], partition_roots[partition_root])
  return cmd
}


BEGIN {
  template = "cd %s && "
  find_template = "find -P . -xdev -name '.*' ! -name . -prune -o -printf '%P\\0%y\\0%s\\0%b\\0%M\\0%n\\0%U\\0%G\\0%T@\\0%l\\0'"
  partition_roots["/"] = "root"
  partition_roots["/data"] = "data"
  partition_roots["/home"] = "home"
}

{
  for (idx in partition_roots) {
    print make_ssh_command($0, idx)
  }
}
