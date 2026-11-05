function make_summon_workspace_command(workspace) {
  return "/opt/homebrew/bin/aerospace summon-workspace " workspace
}

BEGIN {
  focus_next_monitor = "/opt/homebrew/bin/aerospace focus-monitor --wrap-around next"
}

{
  if ($3 == "true") {
    cmd[1] = make_summon_workspace_command($2)
  } else {
    cmd[2] = make_summon_workspace_command($2)
  }
}

END {
  print focus_next_monitor
  print cmd[1]
  print focus_next_monitor
  print cmd[2]
  print focus_next_monitor
}

