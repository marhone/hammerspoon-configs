-- Desc: 记录电池充电状态
-- Author: marhone

require('base.store')
local battery_logs = get_store('battery_logs')

function show_battery_info()
    hs.alert.closeAll()
    text = battery_info_to_text()
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

    local result = {}
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
    local date = os.date("%Y-%m-%d %X", os.time())
    local has_in = false;
    for key, value in pairs(battery_logs) do
        if key == date then
            has_in = true;
            break;
        end
    end
    if not has_in then
        battery_logs[date] = info
        set_store('battery_logs', battery_logs)
    end

    for k, v in pairs(battery_logs) do
        print(k, v['Power Source'])
    end

    return info
end

function battery_info_to_text()
    local info = get_battery_info()

    return to_pretty_strings(info)
end


battery_timer = hs.timer.new(3600 * 6, function()
    local info = get_battery_info()
    hs.notify.new({title="Battery Monitor", informativeText="Cycle Count: " .. info["Cycle Count"]}):send()
end)
battery_timer:start()

-- 查看电池信息
hs.hotkey.bind({"cmd", "alt"}, "b", function()
    show_battery_info()
end)