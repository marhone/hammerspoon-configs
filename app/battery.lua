-- 查看电池信息
hs.hotkey.bind({"cmd", "alt"}, "b", function()
    show_battery_info()
end)

function show_battery_info() 
    hs.alert.closeAll()
    text = get_battery_info()
    hs.alert.show(text, {
        strokeWidth  = 3,
        strokeColor = { white = 1, alpha = 1 },
        fillColor   = { white = 0, alpha = 0.75 },
        textColor = { white = 1, alpha = 1 },
        textFont  = ".AppleSystemUIFont",
        textSize  = 25,
        radius = 15,
        atScreenEdge = 0,
        fadeInDuration = 0.15,
        fadeOutDuration = 0.35,
        padding = 20,
    })
end

function get_battery_info()
    return string.format(
        "%s\nCycle Count:  %s\nPercentage:    %.0f%%",
        hs.battery.powerSource(),
        hs.battery.cycles(),
        hs.battery.percentage()
        )
end