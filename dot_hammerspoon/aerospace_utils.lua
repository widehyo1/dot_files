local M = {}
local hotkeys = {}

function M.focusNextMonitor()
    local task = hs.task.new(
        "/opt/homebrew/bin/aerospace",
        function(exitCode, stdout, stderr)
            if exitCode ~= 0 then
                hs.alert.show(
                    "Monitor switch failed: "
                    .. (stderr ~= "" and stderr or stdout)
                )
            end
        end,
        {"focus-monitor", "--wrap-around", "next"}
    )

    if not task or not task:start() then
        hs.alert.show("Failed to launch AeroSpace.")
    end
end

function M.moveNextMonitor()
    local task = hs.task.new(
        "/opt/homebrew/bin/aerospace",
        function(exitCode, stdout, stderr)
            if exitCode ~= 0 then
                hs.alert.show(
                    "Monitor move failed: "
                    .. (stderr ~= "" and stderr or stdout)
                )
            end
        end,
        {"move-node-to-monitor", "--focus-follows-window", "--wrap-around", "next"}
    )

    if not task or not task:start() then
        hs.alert.show("Failed to launch AeroSpace.")
    end
end

function M.stop()
    for _, hotkey in ipairs(hotkeys) do
        hotkey:delete()
    end
    hotkeys = {}

    -- Remove the global hotkey from the previous implementation.
    if nextMonitorHotkey then
        nextMonitorHotkey:delete()
        nextMonitorHotkey = nil
    end
end

function M.start()
    M.stop()
    hotkeys[#hotkeys + 1] = hs.hotkey.bind(
        {"ctrl", "shift"},
        "m",
        "Focus next monitor",
        M.focusNextMonitor
    )
    hotkeys[#hotkeys + 1] = hs.hotkey.bind(
        {"ctrl", "shift"},
        "n",
        "move next monitor",
        M.moveNextMonitor
    )
end

M.start()
return M
