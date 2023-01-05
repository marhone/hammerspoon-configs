-- 窗口布局
function setScreen(key, x, y, dx, dy)
    hs.hotkey.bind({"alt", "ctrl"}, key, function()
        local win = hs.window.focusedWindow()
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()

        f.x = max.x + max.w * x
        f.y = max.y + max.h * y
        f.w = max.w * dx
        f.h = max.h * dy
        win:setFrame(f)
    end)
end

setScreen("left", 0, 0, 1 / 2, 1)
setScreen("right", 1 / 2, 0, 1 / 2, 1)
setScreen("up", 0, 0, 1, 1 / 2)
setScreen("down", 0, 1 / 2, 1, 1 / 2)

setScreen("U", 0, 0, 1 / 2, 1 / 2)
setScreen("I", 1 / 2, 0, 1, 1 / 2)
setScreen("J", 0, 1 / 2, 1 / 2, 1)
setScreen("K", 1 / 2, 1 / 2, 1, 1)
setScreen("F", 0, 0, 1, 1)
