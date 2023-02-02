local settings = require("hs.settings")

function get_store(key)
    return settings.get("so.victor.hs." .. key) or {}
end

function set_store(key, value)
    settings.set("so.victor.hs." .. key, value)
    return value
end