local M = {}

-- 모든 화면에 있는 Space의 총개수
function M.countSpaces()
    local screens, err = hs.spaces.allSpaces()
    if not screens then
        return nil, err
    end

    local count = 0

    for _, spaceIDs in pairs(screens) do
        count = count + #spaceIDs
    end

    return count
end

-- 화면별 Space ID와 종류 출력
function M.printSpaces()
    local screens, err = hs.spaces.allSpaces()
    if not screens then
        print("Space 조회 실패:", err)
        return
    end

    for screenUUID, spaceIDs in pairs(screens) do
        print("화면 UUID:", screenUUID)

        for index, spaceID in ipairs(spaceIDs) do
            print(string.format(
                "  순번: %d, ID: %d, 종류: %s",
                index,
                spaceID,
                tostring(hs.spaces.spaceType(spaceID))
            ))
        end
    end
end

-- 포커스된 화면의 Space 순번으로 전환. 완료 결과는 callback으로 전달한다.
function M.gotoSpaceByIndex(index, callback, targetScreen)
    callback = callback or function(ok, err)
        print("Space 전환:", ok, err)
    end
    if type(index) ~= "number" or index < 1 or index % 1 ~= 0 then
        return nil, "Space 순번은 1 이상의 정수여야 합니다."
    end
    local screen = targetScreen or hs.screen.mainScreen()
    if not screen then return nil, "포커스된 화면을 찾지 못했습니다." end
    local spaceIDs, err = hs.spaces.spacesForScreen(screen)
    if not spaceIDs then return nil, err end
    local target = spaceIDs[index]
    if not target then
        return nil, string.format("Space 순번 %d이 없습니다 (총 %d개).", index, #spaceIDs)
    end
    if hs.spaces.activeSpaceOnScreen(screen) == target then
        callback(true, nil)
        return true
    end

    local function childWithID(element, identifier)
        for _, child in ipairs(element:attributeValue("AXChildren") or {}) do
            if child:attributeValue("AXIdentifier") == identifier then return child end
        end
    end
    local function findList()
        for _, app in ipairs(hs.application.applicationsForBundleID("com.apple.WindowManager")) do
            local root = hs.axuielement.applicationElement(app)
            for _, display in ipairs(root:attributeValue("AXChildren") or {}) do
                if display:attributeValue("AXIdentifier") == "mc.display" and
                   display:attributeValue("AXDisplayID") == screen:id() then
                    local group = childWithID(display, "mc.spaces")
                    if group then return childWithID(group, "mc.spaces.list") end
                end
            end
        end
    end

    if M.switchTimer then return nil, "이미 Space 전환이 진행 중입니다." end
    hs.spaces.openMissionControl()
    local attempts = 0
    M.switchTimer = hs.timer.doEvery(0.1, function()
        attempts = attempts + 1
        local ok, list = pcall(findList)
        local buttons = ok and list and list:attributeValue("AXChildren") or nil
        if buttons and #buttons == #spaceIDs and buttons[index] then
            M.switchTimer:stop()
            M.switchTimer = nil
            local current = hs.spaces.spacesForScreen(screen)
            if not current or current[index] ~= target then
                callback(nil, "Space 순서가 변경되어 전환을 취소했습니다.")
                return
            end
            local pressed, pressErr = buttons[index]:performAction("AXPress")
            callback(pressed, pressErr)
        elseif attempts >= 30 then
            M.switchTimer:stop()
            M.switchTimer = nil
            callback(nil, "화면의 Space 버튼을 찾지 못했거나 Space 개수가 일치하지 않습니다.")
        end
    end)
    return true
end

-- 포커스된 화면에 데스크탑을 추가한다. 결과는 callback으로 전달한다.
function M.addSpace(callback)
    callback = callback or function(ok, err) print("Space 추가:", ok, err) end
    local screen = hs.screen.mainScreen()
    if not screen then return nil, "포커스된 화면을 찾지 못했습니다." end
    if M.switchTimer then return nil, "다른 Space 작업이 진행 중입니다." end

    local function findDisplay()
        for _, app in ipairs(hs.application.applicationsForBundleID("com.apple.WindowManager")) do
            local root = hs.axuielement.applicationElement(app)
            for _, display in ipairs(root:attributeValue("AXChildren") or {}) do
                if display:attributeValue("AXIdentifier") == "mc.display" and
                   display:attributeValue("AXDisplayID") == screen:id() then
                    return display
                end
            end
        end
    end
    local function findAddButton(display)
        for _, group in ipairs(display:attributeValue("AXChildren") or {}) do
            if group:attributeValue("AXIdentifier") == "mc.spaces" then
                for _, child in ipairs(group:attributeValue("AXChildren") or {}) do
                    if child:attributeValue("AXIdentifier") == "mc.spaces.add" then
                        return child
                    end
                end
            end
        end
    end

    local ok, display = pcall(findDisplay)
    local openedHere = not (ok and display)
    if openedHere then hs.spaces.toggleMissionControl() end
    local attempts = 0
    M.switchTimer = hs.timer.doEvery(0.1, function()
        attempts = attempts + 1
        local found, button = pcall(function()
            local currentDisplay = findDisplay()
            return currentDisplay and findAddButton(currentDisplay)
        end)
        if found and button then
            M.switchTimer:stop()
            M.switchTimer = nil
            local called, pressed, err = pcall(function() return button:performAction("AXPress") end)
            if openedHere then hs.spaces.toggleMissionControl() end
            if not called then callback(nil, pressed)
            else callback(pressed, err) end
        elseif attempts >= 30 then
            M.switchTimer:stop()
            M.switchTimer = nil
            if openedHere then hs.spaces.toggleMissionControl() end
            callback(nil, "화면의 Space 추가 버튼을 찾지 못했습니다.")
        end
    end)
    return true
end

-- 현재 Space의 일반 창을 지정한 순번의 일반 데스크탑으로 이동한다.
-- 대상 순번을 생략하면 이전 일반 데스크탑을 찾고, 없으면 마지막 일반 데스크탑을 사용한다.
function M.moveCurrentSpaceWindows(targetIndex, targetScreen)
    local screen = targetScreen or hs.screen.mainScreen()
    if not screen then return nil, "포커스된 화면을 찾지 못했습니다." end
    if M.switchTimer then return nil, "다른 Space 작업이 진행 중입니다." end
    local source, err = hs.spaces.activeSpaceOnScreen(screen)
    if not source then return nil, err end
    if hs.spaces.spaceType(source) ~= "user" then
        return nil, "전체 화면 Space의 창은 이동하지 않습니다."
    end
    local ids, listErr = hs.spaces.spacesForScreen(screen)
    if not ids then return nil, listErr end
    local sourceIndex
    for i, id in ipairs(ids) do if id == source then sourceIndex = i; break end end
    if not sourceIndex then return nil, "현재 Space를 목록에서 찾지 못했습니다." end
    if targetIndex == nil then
        for i = sourceIndex - 1, 1, -1 do
            if hs.spaces.spaceType(ids[i]) == "user" then targetIndex = i; break end
        end
        if not targetIndex then
            for i = #ids, sourceIndex + 1, -1 do
                if hs.spaces.spaceType(ids[i]) == "user" then targetIndex = i; break end
            end
        end
        if not targetIndex then return nil, "이동할 다른 일반 데스크탑이 없습니다." end
    end
    if type(targetIndex) ~= "number" or targetIndex < 1 or targetIndex % 1 ~= 0 then
        return nil, "대상 Space 순번은 1 이상의 정수여야 합니다."
    end
    local destination = ids[targetIndex]
    if not destination then return nil, "대상 Space 순번이 없습니다: " .. targetIndex end
    if destination == source then return nil, "현재 Space는 이동 대상이 될 수 없습니다." end
    if hs.spaces.spaceType(destination) ~= "user" then
        return nil, "이동 대상은 일반 데스크탑이어야 합니다."
    end
    local windows = {}
    for _, win in ipairs(hs.window.allWindows()) do
        if win:isStandard() and win:id() then
            local memberships, windowErr = hs.spaces.windowSpaces(win)
            if not memberships then return nil, "창의 Space 조회 실패: " .. tostring(windowErr) end
            for _, id in ipairs(memberships) do
                if id == source then
                    if #memberships ~= 1 then
                        return nil, "여러 Space에 속한 창이 있어 작업을 중단했습니다: " .. (win:title() or "")
                    end
                    windows[#windows + 1] = win
                    break
                end
            end
        end
    end
    local movedCount = 0
    for _, win in ipairs(windows) do
        local moved, moveErr = hs.spaces.moveWindowToSpace(win, destination)
        if not moved then
            return nil, string.format("%d개 창을 이동한 뒤 실패했습니다: %s", movedCount, tostring(moveErr))
        end
        local after, afterErr = hs.spaces.windowSpaces(win:id())
        local found = false
        for _, id in ipairs(after or {}) do if id == destination then found = true; break end end
        if not found then
            return nil, string.format("%d개 창 이동 후 다음 창의 이동을 확인하지 못했습니다: %s", movedCount, tostring(afterErr or hs.inspect(after)))
        end
        movedCount = movedCount + 1
    end
    return true, { screen = screen, source = source, sourceIndex = sourceIndex,
        destination = destination, destinationIndex = targetIndex, movedCount = movedCount }
end

-- 창을 이동한 뒤 현재 일반 Space를 삭제한다.
function M.removeCurrentSpace(targetIndex, callback)
    if type(targetIndex) == "function" and callback == nil then
        callback, targetIndex = targetIndex, nil
    end
    callback = callback or function(ok, err)
        if ok then print("Space 삭제 완료") else hs.alert.show(tostring(err)) end
    end
    local screen = hs.screen.mainScreen()
    if not screen then return nil, "포커스된 화면을 찾지 못했습니다." end
    local ids, err = hs.spaces.spacesForScreen(screen)
    if not ids then return nil, err end
    local source = hs.spaces.activeSpaceOnScreen(screen)
    if not source then return nil, "현재 Space를 찾지 못했습니다." end
    if hs.spaces.spaceType(source) == "fullscreen" then
        local win = hs.window.focusedWindow()
        if not win or not win:isFullScreen() then
            return nil, "현재 전체 화면 창을 찾지 못했습니다."
        end
        local memberships, membershipErr = hs.spaces.windowSpaces(win)
        if not memberships then return nil, "창의 Space 조회 실패: " .. tostring(membershipErr) end
        local matches = false
        for _, id in ipairs(memberships) do if id == source then matches = true; break end end
        if not matches then return nil, "포커스된 창이 현재 Space에 속하지 않습니다." end
        if M.switchTimer then return nil, "다른 Space 작업이 진행 중입니다." end
        local ok, exitErr = pcall(function() win:setFullScreen(false) end)
        if not ok then return nil, "전체 화면 해제 요청 실패: " .. tostring(exitErr) end
        local attempts = 0
        M.switchTimer = hs.timer.doEvery(0.1, function()
            attempts = attempts + 1
            local spaces, listErr = hs.spaces.spacesForScreen(screen)
            local exists = false
            if spaces then
                for _, id in ipairs(spaces) do if id == source then exists = true; break end end
            end
            if spaces and not exists then
                M.switchTimer:stop(); M.switchTimer = nil
                callback(true, nil)
            elseif attempts >= 50 then
                M.switchTimer:stop(); M.switchTimer = nil
                callback(nil, "전체 화면 Space 해제를 확인하지 못했습니다: " .. tostring(listErr or "시간 초과"))
            end
        end)
        return true
    end
    if hs.spaces.spaceType(source) ~= "user" then
        return nil, "지원하지 않는 Space 종류입니다."
    end
    local userCount = 0
    for _, id in ipairs(ids) do
        if hs.spaces.spaceType(id) == "user" then userCount = userCount + 1 end
    end
    if userCount <= 1 then
        hs.alert.show("마지막 일반 데스크탑은 삭제할 수 없습니다.")
        return nil, "마지막 일반 데스크탑입니다."
    end
    local moved, info = M.moveCurrentSpaceWindows(targetIndex, screen)
    if not moved then return nil, info end
    local sourceIndex, destination, destinationIndex = info.sourceIndex, info.destination, info.destinationIndex

    local started, switchErr = M.gotoSpaceByIndex(destinationIndex, function(switched, switchError)
        if not switched then callback(nil, switchError); return end
        local attempts = 0
        M.switchTimer = hs.timer.doEvery(0.1, function()
            attempts = attempts + 1
            if hs.spaces.activeSpaceOnScreen(screen) == destination then
                M.switchTimer:stop()
                M.switchTimer = nil
                local now = hs.spaces.spacesForScreen(screen)
                if not now or now[sourceIndex] ~= source then
                    callback(nil, "Space 순서가 변경되어 삭제를 중단했습니다.")
                    return
                end
                hs.spaces.toggleMissionControl()
                local waits = 0
                M.switchTimer = hs.timer.doEvery(0.1, function()
                    waits = waits + 1
                    local ok, result, actionErr = pcall(function()
                        for _, app in ipairs(hs.application.applicationsForBundleID("com.apple.WindowManager")) do
                            local root = hs.axuielement.applicationElement(app)
                            for _, display in ipairs(root:attributeValue("AXChildren") or {}) do
                                if display:attributeValue("AXIdentifier") == "mc.display" and display:attributeValue("AXDisplayID") == screen:id() then
                                    for _, group in ipairs(display:attributeValue("AXChildren") or {}) do
                                        if group:attributeValue("AXIdentifier") == "mc.spaces" then
                                            for _, list in ipairs(group:attributeValue("AXChildren") or {}) do
                                                if list:attributeValue("AXIdentifier") == "mc.spaces.list" then
                                                    local children = list:attributeValue("AXChildren") or {}
                                                    local current = hs.spaces.spacesForScreen(screen)
                                                    if current and current[sourceIndex] == source and #children == #current then
                                                        return children[sourceIndex]:performAction("AXRemoveDesktop")
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        return nil, "not ready"
                    end)
                    if ok and (result or actionErr ~= "not ready") then
                        M.switchTimer:stop(); M.switchTimer = nil
                        hs.spaces.toggleMissionControl()
                        callback(result, actionErr)
                    elseif waits >= 30 then
                        M.switchTimer:stop(); M.switchTimer = nil
                        hs.spaces.toggleMissionControl()
                        callback(nil, "Space 삭제 버튼을 찾지 못했습니다.")
                    end
                end)
            elseif attempts >= 30 then
                M.switchTimer:stop(); M.switchTimer = nil
                callback(nil, "대상 Space 전환을 확인하지 못했습니다.")
            end
        end)
    end, screen)
    if not started then return nil, switchErr end
    return true
end

local hotkeys = {}

function M.start()
    M.stop()
    local removeHotkey = hs.hotkey.bind({"ctrl", "alt", "cmd"}, "w", function()
        local ok, err = M.removeCurrentSpace(function(removed, removeErr)
            if not removed then hs.alert.show("Space 정리 실패: " .. tostring(removeErr)) end
        end)
        if not ok then hs.alert.show(tostring(err)) end
    end)
    if removeHotkey then
        hotkeys[#hotkeys + 1] = removeHotkey
    else
        print("Space 정리 단축키 등록 실패")
    end
    local addHotkey = hs.hotkey.bind({"ctrl", "alt", "cmd"}, "n", function()
        local ok, err = M.addSpace(function(added, addErr)
            if not added then hs.alert.show("Space 추가 실패: " .. tostring(addErr)) end
        end)
        if not ok then hs.alert.show(tostring(err)) end
    end)
    if addHotkey then
        hotkeys[#hotkeys + 1] = addHotkey
    else
        print("Space 추가 단축키 등록 실패")
    end
    for index = 1, 9 do
        local hotkey = hs.hotkey.bind({"ctrl", "alt", "cmd"}, tostring(index), function()
            local ok, err = M.gotoSpaceByIndex(index, function(switched, switchErr)
                if not switched then
                    hs.alert.show("Space 전환 실패: " .. tostring(switchErr))
                end
            end)
            if not ok then hs.alert.show(tostring(err)) end
        end)
        if hotkey then
            hotkeys[#hotkeys + 1] = hotkey
        else
            print("Space 단축키 등록 실패:", index)
        end
    end
end

function M.stop()
    for _, hotkey in ipairs(hotkeys) do hotkey:delete() end
    hotkeys = {}
    if M.switchTimer then M.switchTimer:stop(); M.switchTimer = nil end
end

return M
