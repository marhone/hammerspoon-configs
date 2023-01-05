-- 快速插入当前时间
hs.hotkey.bind({"cmd", "alt"}, "n", function()
    local date = os.date()
    hs.eventtap.keyStrokes(date .. "\n")
end)