function getKeybindings()
    local bindings = {}

    for _, hotkey in ipairs(hs.hotkey.getHotkeys()) do
        local key = hotkey.idx
            :gsub("⌃", "Ctrl+")
            :gsub("⌥", "Alt+")
            :gsub("⇧", "Shift+")
            :gsub("⌘", "Cmd+")

        local description = hotkey.msg or ""
        if description:sub(1, #hotkey.idx) == hotkey.idx then
            description = description:sub(#hotkey.idx + 1)
        end

        description = description
            :gsub("[\t\r\n]", " ")
            :match("^%s*(.-)%s*$")

        bindings[#bindings + 1] = {
            key = key,
            description = description ~= "" and description or "(설명 없음)",
        }
    end

    return bindings
end

function formatKeybindingsTsv(bindings)
    local rows = {"키\t역할"}
    for _, binding in ipairs(bindings) do
        rows[#rows + 1] = binding.key .. "\t" .. binding.description
    end
    return table.concat(rows, "\n")
end

function showKeybindings()
    local rows = {}
    for _, binding in ipairs(getKeybindings()) do
        rows[#rows + 1] = binding.key .. "  →  " .. binding.description
    end
    hs.alert.show(table.concat(rows, "\n"), 10)
end


function printKeybindings() 
    return formatKeybindingsTsv(getKeybindings())
end

-- Reload Hammerspoon configuration.
if reloadConfigHotkey then reloadConfigHotkey:delete() end
reloadConfigHotkey = hs.hotkey.bind({"ctrl", "shift"}, "r", "reload config", hs.reload)

return M
