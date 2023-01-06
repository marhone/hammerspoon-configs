-- 查看电池信息
hs.hotkey.bind({"cmd", "alt"}, "b", function()
    show_battery_info()
end)

function show_battery_info() 
    hs.alert.closeAll()
    text = get_battery_info()
    hs.alert.show(text, ALERT_TEXT_STYLE)
end

function get_battery_info()
    return string.format(
        "%s\nCycle Count:  %s\nPercentage:    %.0f%%",
        hs.battery.powerSource(),
        hs.battery.cycles(),
        hs.battery.percentage()
        )
end