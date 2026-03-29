.[0]
| .HostConfig as $hostconfig
| {
  Args,
  HostConfig: $hostconfig | {
    NetworkMode,
    PortBindings,
    VolumeDriver,
    VolumesFrom
  },
  State
}
