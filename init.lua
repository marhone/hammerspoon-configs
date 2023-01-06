require("base.autoload_config")

require("app.manipulation")
require("app.battery")
require("app.clipboard")

-- 测试脚本
hs.hotkey.bind({"cmd", "alt"}, "t", function()
    hs.toggleConsole()
end)

