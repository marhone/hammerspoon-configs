-- 查看电池信息
hs.hotkey.bind({"cmd", "alt"}, "b", function()
    show_battery_info()
end)

function show_battery_info()
    hs.alert.closeAll()
    text = get_battery_info()
    hs.alert.show(text, {
        strokeWidth = 3,
        strokeColor = {
            white = 1,
            alpha = 1
        },
        fillColor = {
            white = 0,
            alpha = 0.75
        },
        textColor = {
            white = 1,
            alpha = 1
        },
        textFont = "Arial Black",
        textSize = 16,
        radius = 15,
        atScreenEdge = 0,
        fadeInDuration = 0.15,
        fadeOutDuration = 0.35,
        padding = 20
    })
end

-- Prettry Print Lines
function to_pretty_strings(list)
    local ranges = {}
    local spaces = 10
    local max_length = 0

    for k, v in pairs(list) do
        local length = #k + spaces + #tostring(v)
        if max_length < length then
            max_length = length
        end
    end

    result = {}
    for k, v in pairs(list) do
        local length = #k + spaces + #tostring(v)
        -- 空格样式
        local white = "-"
        if length < max_length then
            white = string.rep(white, (max_length - length) + spaces)
        else
            white = string.rep(white, spaces)
        end

        local line = string.format("%s%s%s", k, white, v)
        table.insert(result, line)
    end

    return table.concat(result, "\n")
end

function get_battery_info()
    local info = {
        ["Is Charging"] = hs.battery.isCharging(),
        ["Percentage"] = string.format("%.0f%%", hs.battery.percentage()),
        ["Power Source"] = hs.battery.powerSource(),
        ["Cycle Count"] = hs.battery.cycles(),
    }

    return to_pretty_strings(info)
end


-- local timer = hs.timer.new(10, show_battery_info)
-- timer:start()