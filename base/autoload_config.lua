-- 自动加载脚本
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
-- hs.notify.new({title="Hammerspoon", informativeText="Lua script reloaded."}):send()

local date = os.date()
local message = 'Hammerspoon scripts reloaded. 🎉'
hs.alert.show(string.format("%s\n%s", date, message), {
    strokeWidth  = 3,
    strokeColor = { white = 1, alpha = 1 },
    fillColor   = { white = 0, alpha = 0.75 },
    textColor = { white = 1, alpha = 1 },
    textFont  = "Arial Black",
    textSize  = 17,
    radius = 15,
    atScreenEdge = 0,
    fadeInDuration = 0.15,
    fadeOutDuration = 0.35,
    padding = 20,
});
