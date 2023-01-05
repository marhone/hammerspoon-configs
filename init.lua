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

