require("hs.ipc")

dofile(hs.configdir .. "/hs_utils.lua")

if applicationControl then applicationControl.stop() end
applicationControl = dofile(hs.configdir .. "/application_control.lua")

aerospaceUtil = dofile(hs.configdir .. "/aerospace_utils.lua")
aerospaceUtil.start()

if missionControl then missionControl.stop() end
missionControl = dofile(hs.configdir .. "/mission_control.lua")

