require("base.autoload_config")

-- require("app.windows")
require("app.manipulation")
require("app.battery")
require("app.clipboard")

-- require("app.colorpicker")

hs.loadSpoon("ClipShow")

-- 测试脚本
hs.hotkey.bind({"cmd", "alt"}, "t", function()
    hs.toggleConsole()
end)

local men = hs.menubar.new()
men:setTooltip("helo")
men:setTitle("hello")

men:setMenu({{
    title = "my menu item",
    fn = function()
        print("you clicked my menu item!")
    end,
    checked = true
}, {
    title = '-'
}, {
    title = "item 2",
    fn = function()
        print("you clicked my menu item!")
    end,
    state = "off",
    tooltip = "2121"
}})

