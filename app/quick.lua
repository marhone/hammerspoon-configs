
-- Hammer console
hs.hotkey.bind({"cmd", "alt"}, "c", function()
    hs.toggleConsole()
end)

-- 测试脚本
hs.hotkey.bind({"cmd", "alt"}, "t", function()
    hs.alert.show("cmd + alt + t", ALERT_TEXT_STYLE);
end)

-- Unotes
hs.hotkey.bind({"cmd", "alt"}, "n", function()
    hs.application.open('/Applications/unotes.app')
end)


-- 语雀
hs.hotkey.bind({"cmd", "alt"}, "p", function()
    hs.application.open('/Applications/语雀.app')
end)
