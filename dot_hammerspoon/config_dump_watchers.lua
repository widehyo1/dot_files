-- Reload changed app configurations, then silently record their keybindings.
local M = {}
local home = os.getenv("HOME")
local ghostty = "/Applications/Ghostty.app/Contents/MacOS/ghostty"
local entries = {
    aerospace = {
        directory = home .. "/.config/aerospace",
        matches = function(path) return path:match("%.toml$") ~= nil end,
    },
    ghostty = {
        directory = home .. "/.config/ghostty",
        matches = function(path)
            return path:match("/config$") ~= nil or path:match("%.ghostty$") ~= nil
        end,
    },
    hammerspoon = {
        directory = hs.configdir,
        matches = function(path) return path:match("%.lua$") ~= nil end,
        changedFiles = {},
    },
}
local queueChange

local function finish(name, entry)
    entry.busy = false
    if entry.pending then
        entry.pending = false
        queueChange(name, entry)
    end
end

local function runTask(name, entry, executable, args, onSuccess)
    local task = hs.task.new(executable, function(code, _, stderr)
        entry.task = nil
        if code ~= 0 then
            hs.printf("%s config reload/dump failed (%s): %s", name, code, stderr)
            finish(name, entry)
        elseif onSuccess then
            onSuccess()
        else
            finish(name, entry)
        end
    end, args)
    if not task then
        hs.printf("%s config reload/dump: could not create task", name)
        finish(name, entry)
        return
    end
    local env = task:environment()
    env.HOME = home
    env.PATH = "/opt/homebrew/bin:/usr/local/bin:/Applications/Ghostty.app/Contents/MacOS:/usr/bin:/bin:/usr/sbin:/sbin"
    task:setEnvironment(env)
    entry.task = task
    if not task:start() then
        entry.task = nil
        hs.printf("%s config reload/dump: could not start task", name)
        finish(name, entry)
    end
end

local function dump(name, entry)
    runTask(name, entry, "/bin/bash", {
        home .. "/keybindings/dump-" .. name .. "-keybinding.sh", "--silent",
    })
end

local function reloadAndDump(name, entry)
    if entry.busy then
        entry.pending = true
        return
    end
    entry.busy = true
    if name == "aerospace" then
        runTask(name, entry, "/opt/homebrew/bin/aerospace", {"reload-config", "--no-gui"}, function()
            dump(name, entry)
        end)
    elseif name == "ghostty" then
        -- Reject invalid config before invoking the running app's reload menu.
        runTask(name, entry, ghostty, {"+validate-config"}, function()
            local app = hs.application.get("com.mitchellh.ghostty")
            if not app or not app:selectMenuItem({"Ghostty", "Reload Configuration"}) then
                hs.printf("ghostty config reload: running app or reload menu unavailable")
                finish(name, entry)
                return
            end
            -- Allow the app's menu action to run before recording bindings.
            entry.afterReload = hs.timer.doAfter(0.5, function()
                entry.afterReload = nil
                dump(name, entry)
            end)
        end)
    else
        -- A syntax error must not tear down the working watcher environment.
        for path in pairs(entry.changedFiles) do
            if hs.fs.attributes(path, "mode") == "file" then
                local chunk, err = loadfile(path)
                if not chunk then
                    hs.printf("hammerspoon config reload skipped: %s", err)
                    finish(name, entry)
                    return
                end
            end
        end
        entry.changedFiles = {}
        -- The new environment calls M.start(), which schedules its own dump.
        hs.reload()
    end
end

queueChange = function(name, entry)
    if entry.timer then entry.timer:stop() end
    entry.timer = hs.timer.doAfter(1, function()
        entry.timer = nil
        reloadAndDump(name, entry)
    end)
end

function M.start()
    for name, entry in pairs(entries) do
        if entry.watcher then entry.watcher:stop() end
        entry.watcher = hs.pathwatcher.new(entry.directory, function(paths)
            local changed = false
            for _, path in ipairs(paths) do
                if entry.matches(path) then
                    changed = true
                    if entry.changedFiles then entry.changedFiles[path] = true end
                end
            end
            if changed then queueChange(name, entry) end
        end):start()
    end
    -- Only dump on startup; automatically reloading here would create a loop.
    local entry = entries.hammerspoon
    entry.startupTimer = hs.timer.doAfter(1, function()
        entry.startupTimer = nil
        if not entry.busy then
            entry.busy = true
            dump("hammerspoon", entry)
        end
    end)
end

function M.stop()
    for _, entry in pairs(entries) do
        if entry.watcher then entry.watcher:stop(); entry.watcher = nil end
        for _, field in ipairs({"timer", "afterReload", "startupTimer"}) do
            if entry[field] then entry[field]:stop(); entry[field] = nil end
        end
        entry.pending = false
        if entry.task then entry.task:setCallback(nil); entry.task:terminate(); entry.task = nil end
        entry.busy = false
    end
end

return M
