-- Mission Control keyboard navigation for macOS 27 / Hammerspoon 1.1.1.
-- Loaded by ~/.hammerspoon/init.lua. Selection is independent of app focus.
local M = {}
local selected, outline
local swallowed = {}
local types = hs.eventtap.event.types
local keys = hs.keycodes.map
local log = hs.logger.new("MCKeyboard", "warning")

local function attr(element, name)
    return element:attributeValue(name)
end

local function clear()
    selected = nil
    if outline then outline:delete(); outline = nil end
end

-- macOS 27 exposes mc.display directly under WindowManager, not Dock.
local function snapshot()
    local displays, windows = {}, {}
    for _, app in ipairs(hs.application.applicationsForBundleID("com.apple.WindowManager")) do
        local root = hs.axuielement.applicationElement(app)
        for _, element in ipairs(attr(root, "AXChildren") or {}) do
            if attr(element, "AXIdentifier") == "mc.display" then
                displays[#displays + 1] = element
            end
        end
    end
    for _, display in ipairs(displays) do
        for _, element in ipairs(attr(display, "AXChildren") or {}) do
            local identifier = attr(element, "AXIdentifier") or ""
            local bundle = identifier:match("^(.-)%.space%.%d+$")
            if bundle and attr(element, "AXRole") == "AXButton" then
                local position = attr(element, "AXPosition")
                local size = attr(element, "AXSize")
                if position and size and size.w > 0 and size.h > 0 then
                    windows[#windows + 1] = {
                        element = element, bundle = bundle,
                        title = attr(element, "AXTitle") or "",
                        frame = {x = position.x, y = position.y, w = size.w, h = size.h},
                    }
                end
            end
        end
    end
    table.sort(windows, function(a, b)
        if a.frame.y ~= b.frame.y then return a.frame.y < b.frame.y end
        if a.frame.x ~= b.frame.x then return a.frame.x < b.frame.x end
        if a.bundle ~= b.bundle then return a.bundle < b.bundle end
        return a.title < b.title
    end)
    return #displays > 0, windows
end

local function findSelected(windows)
    if not selected then return nil end
    for index, item in ipairs(windows) do
        if item.element == selected.element then return index end
    end
end

local function mark(item)
    if outline then outline:delete() end
    outline = hs.canvas.new(item.frame)
    outline:level(hs.canvas.windowLevels.screenSaver)
    outline:behavior({"canJoinAllSpaces", "stationary", "ignoresCycle"})
    outline:appendElements({
        type = "rectangle", action = "stroke",
        strokeColor = {red = 0.1, green = 0.65, blue = 1, alpha = 1},
        strokeWidth = 5,
        roundedRectRadii = {xRadius = 8, yRadius = 8},
        frame = {x = 3, y = 3, w = item.frame.w - 6, h = item.frame.h - 6},
    })
    selected = item
    outline:show()
end

local function quitSelected(item)
    local apps = hs.application.applicationsForBundleID(item.bundle)
    -- A thumbnail identifies a bundle, not a PID. Do not guess between instances.
    if #apps ~= 1 then
        hs.alert.show("앱 인스턴스를 확정할 수 없습니다.")
        return
    end
    local app = apps[1]
    clear()
    hs.spaces.closeMissionControl()
    -- Normal termination request, equivalent in intent to Cmd+Q, never kill9.
    -- Close Mission Control first so save/cancel dialogs remain visible.
    M.quitTimer = hs.timer.doAfter(0.3, function()
        M.quitTimer = nil
        if app:isRunning() then
            app:activate()
            app:kill()
        end
    end)
end

-- Find the add-desktop accessibility button in macOS 27 Mission Control.
local function addSpace()
    local screen = hs.mouse.getCurrentScreen() or hs.screen.mainScreen()
    local frame = screen:fullFrame()
    local function findButton(element, depth)
        if depth > 12 then return nil end
        if attr(element, "AXRole") == "AXButton" then
            local identifier = (attr(element, "AXIdentifier") or ""):lower()
            local label = ((attr(element, "AXDescription") or "") .. " " ..
                (attr(element, "AXTitle") or "")):lower()
            local isAdd = identifier:match("^mc%..*add") or
                label:find("add desktop", 1, true) or
                label:find("add space", 1, true) or
                label:find("데스크탑 추가", 1, true) or
                label:find("데스크탑 생성", 1, true)
            local position, size = attr(element, "AXPosition"), attr(element, "AXSize")
            if isAdd and position and size then
                local x, y = position.x + size.w / 2, position.y + size.h / 2
                if x >= frame.x and x < frame.x + frame.w and
                    y >= frame.y and y < frame.y + frame.h then
                    return element
                end
            end
        end
        for _, child in ipairs(attr(element, "AXChildren") or {}) do
            local button = findButton(child, depth + 1)
            if button then return button end
        end
    end
    for _, app in ipairs(hs.application.applicationsForBundleID("com.apple.WindowManager")) do
        local root = hs.axuielement.applicationElement(app)
        for _, display in ipairs(attr(root, "AXChildren") or {}) do
            if attr(display, "AXIdentifier") == "mc.display" then
                local button = findButton(display, 0)
                if button then
                    local result, err = button:performAction("AXPress")
                    if not result then hs.alert.show("Space 생성 실패: " .. tostring(err)) end
                    return
                end
            end
        end
    end
    hs.alert.show("현재 화면의 Space 추가 버튼을 찾지 못했습니다.")
end

local function handle(event)
    local code = event:getKeyCode()
    if event:getType() == types.keyUp then
        if swallowed[code] then swallowed[code] = nil; return true end
        return false
    end
    -- Consume repeats of an already intercepted key, even after MC closes.
    if swallowed[code] then return true end
    local flags = event:getFlags()
    local tab = code == keys.tab and not (flags.cmd or flags.alt or flags.ctrl or flags.fn)
    local quit = code == keys.q and flags.cmd and not (flags.alt or flags.ctrl or flags.shift or flags.fn)
    local enter = code == keys["return"] and not (flags.cmd or flags.alt or flags.ctrl or flags.shift or flags.fn)
    local newSpace = code == keys.n and flags.ctrl and flags.shift and
        not (flags.cmd or flags.alt or flags.fn)
    if not (tab or quit or enter or newSpace) then return false end

    local active, windows = snapshot()
    if not active then clear(); return false end
    local index = findSelected(windows)
    if not index then clear() end

    if newSpace then
        swallowed[code] = true
        clear()
        addSpace()
        return true
    elseif tab then
        swallowed[code] = true
        if #windows == 0 then
            hs.alert.show("Mission Control 창 썸네일을 읽지 못했습니다.")
        else
            local nextIndex
            if index then
                nextIndex = ((index - 1 + (flags.shift and -1 or 1)) % #windows) + 1
            else
                nextIndex = flags.shift and #windows or 1
            end
            mark(windows[nextIndex])
        end
        return true
    elseif quit then
        -- Never let Cmd+Q reach the previously active app while in Mission Control.
        swallowed[code] = true
        if index then quitSelected(windows[index])
        else hs.alert.show("먼저 Tab으로 종료할 앱의 창을 선택하세요.") end
        return true
    elseif enter and index then
        swallowed[code] = true
        local element = windows[index].element
        clear()
        local result, err = element:performAction("AXPress")
        if not result then
            hs.alert.show("창 선택 실패: " .. tostring(err))
        end
        return true
    end
    return false
end

M.tap = hs.eventtap.new({types.keyDown, types.keyUp}, function(event)
    local ok, result = pcall(handle, event)
    if not ok then
        clear()
        log.e(result)
        -- Fail closed for Cmd+Q if AX lookup failed.
        local flags = event:getFlags()
        if event:getKeyCode() == keys.q and flags.cmd then
            hs.alert.show("Mission Control 조회 오류. Hammerspoon Console을 확인하세요.")
            return true
        end
        return false
    end
    return result
end):start()

-- Clear selection after Escape, clicking a window, or leaving Mission Control.
M.poll = hs.timer.doEvery(0.2, function()
    if not selected then return end
    local ok, active, windows = pcall(snapshot)
    if not ok or not active then clear(); return end
    local index = findSelected(windows)
    if not index then clear(); return end
    local frame = windows[index].frame
    selected = windows[index]
    if outline then outline:frame(frame) end
end)

function M.stop()
    M.tap:stop()
    M.poll:stop()
    if M.quitTimer then M.quitTimer:stop(); M.quitTimer = nil end
    clear()
end

return M
