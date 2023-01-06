function make_browser()
    local screen = require "hs.screen"
    local webview = require "hs.webview"

    local mainScreenFrame = screen:primaryScreen():frame()
    local margin = 200
    browserFrame = {
        x = mainScreenFrame.x + margin,
        y = mainScreenFrame.y + margin,
        h = mainScreenFrame.h - 2 * margin,
        w = mainScreenFrame.w - 2 * margin
    }

    local options = {
        developerExtrasEnabled = true
    }

    -- https://github.com/Hammerspoon/hammerspoon/blob/master/extensions/webview/libwebview.m#L2147
    local browser = webview.new(browserFrame, options):windowStyle(2 + 4 + 8 + 128 + 256):closeOnEscape(true)
        :deleteOnClose(true):bringToFront(true):allowTextEntry(true):transparent(true)

    return browser
end

local browser = nil
local shown = false

hs.hotkey.bind({"cmd", "alt"}, "n", function()
    local path = "file://" .. hs.spoons.scriptPath() .. "tinker/tinker.html"
    if browser == nil then
        browser = make_browser()
    end
    if not shown then
        shown = true
        browser:url(path)
        browser:show()
    else 
        shown = false
        browser:delete()
        browser = nil
    end
end)
