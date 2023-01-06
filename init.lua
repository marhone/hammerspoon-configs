require("base.autoload_config")
require("base.common")

require("app.manipulation")
require("app.battery")
require("app.clipboard")
require("app.tinker")

-- Hammer console
hs.hotkey.bind({"cmd", "alt"}, "p", function()
    hs.toggleConsole()
end)

-- 测试脚本
hs.hotkey.bind({"cmd", "alt"}, "t", function()
    hs.alert.show("cmd + alt + t", ALERT_TEXT_STYLE);
end)