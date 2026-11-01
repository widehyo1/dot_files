-- Launch an application, or focus it if it is already running.
local M = {}
local modifiers = {"ctrl", "shift"}
local hotkeys = {}

local function bindApplication(key, bundleID, name)
    hotkeys[#hotkeys + 1] = hs.hotkey.bind(modifiers, key, name, function()
        if not hs.application.launchOrFocusByBundleID(bundleID) then
            hs.alert.show(name .. " 실행 또는 전환에 실패했습니다.")
        end
    end)
end

bindApplication("c", "com.google.Chrome", "Chrome")
hotkeys[#hotkeys + 1] = hs.hotkey.bind(modifiers, "e", "Edge", function()
    hs.execute('open -na "Microsoft Edge" --args -inprivate')
end)
bindApplication("g", "com.mitchellh.ghostty", "Ghostty")
bindApplication("d", "org.jkiss.dbeaver.core.product", "DBeaver")


function M.stop()
    for _, hotkey in ipairs(hotkeys) do
        hotkey:delete()
    end
    hotkeys = {}
end

return M
