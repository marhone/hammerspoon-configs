-- Author: marhone
-- Desc:   clipboard
local module = {
    version = '1.0.1'
}

require('base.substring')
local hashfn = require("hs.hash").MD5

local frequency = 0.8 -- Speed in seconds to check for clipboard changes. If you check too frequently, you will loose performance, if you check sparsely you will loose copies
local hist_size = 100 -- How many items to keep on history
local label_length = 50 -- How wide (in characters) the dropdown menu should be. Copies larger than this will have their label truncated and end with "…" (unicode for elipsis ...)
local honor_clearcontent = false -- asmagill request. If any application clears the pasteboard, we also remove it from the history https://groups.google.com/d/msg/hammerspoon/skEeypZHOmM/Tg8QnEj_N68J
local pasteOnSelect = false -- Auto-type on click
local tooltip_size = 300 -- tooltip string max length

local popboard = hs.menubar.new()
popboard:setTooltip("clipboard")
local pasteboard = require("hs.pasteboard") -- http://www.hammerspoon.org/docs/hs.pasteboard.html
local settings = require("hs.settings") -- http://www.hammerspoon.org/docs/hs.settings.html
local last_change = pasteboard.changeCount() -- displays how many times the pasteboard owner has changed // Indicates a new copy has been made

-- Array to store the clipboard history
local clipboard_history = settings.get("so.victor.hs.jumpcut") or {} -- If no history is saved on the system, create an empty history
local favorites = settings.get("so.victor.hs.jumpcut_favorites") or {} -- Favorites items

-- Append a history counter to the menu
local function setTitle()
    if (#clipboard_history == 0) then
        popboard:setTitle("✂") -- Unicode magic
    else
        popboard:setTitle("✂") -- Unicode magic
        -- jumpcut:setTitle("✂ ("..#clipboard_history..")") -- updates the menu counter
    end
end

local function putOnPaste(string, key)
    if (pasteOnSelect) then
        hs.eventtap.keyStrokes(string)
        pasteboard.setContents(string)
        last_change = pasteboard.changeCount()
    else
        -- if (key.alt == true) then -- If the option/alt key is active when clicking on the menu, perform a "direct paste", without changing the clipboard
        --     hs.eventtap.keyStrokes(string) -- Defeating paste blocking http://www.hammerspoon.org/go/#pasteblock
        -- else
        --     pasteboard.setContents(string)
        --     last_change = pasteboard.changeCount() -- Updates last_change to prevent item duplication when putting on paste
        -- end
        pasteboard.setContents(string)
        last_change = pasteboard.changeCount() -- Updates last_change to prevent item duplication when putting on paste
    end
    -- 重新排列顺序
    rerange_clipborad_list(string)
end

local function addToFavorite(string, key)
    table.insert(favorites, string)
    rerange_favorites_list(string)

    settings.set('so.victor.hs.jumpcut_favorites', favorites)
end

local function loadFavorites()
    return settings.get("so.victor.hs.jumpcut_favorites") or {}
end

-- Clears the clipboard and history
local function clearAll()
    pasteboard.clearContents()
    clipboard_history = {}
    settings.set("so.victor.hs.jumpcut", clipboard_history)
    now = pasteboard.changeCount()
    setTitle()
end

local function clearFavorites()
    favorites = {}
    settings.set('so.victor.hs.jumpcut_favorites', favorites)
end

-- Clears the last added to the history
local function clearLastItem()
    table.remove(clipboard_history, #clipboard_history)
    settings.set("so.victor.hs.jumpcut", clipboard_history)
    now = pasteboard.changeCount()
    setTitle()
end

local function pasteboardToClipboard(item)
    -- Loop to enforce limit on qty of elements in history. Removes the oldest items
    while (#clipboard_history >= hist_size) do
        table.remove(clipboard_history, 1)
    end
    rerange_clipborad_list(item)
    settings.set("so.victor.hs.jumpcut", clipboard_history) -- updates the saved history
    setTitle() -- updates the menu counter
end

local function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function rerange_clipborad_list(item)
    if item == nil or trim(item) == '' then
        return
    end
    table.insert(clipboard_history, item)
    -- Remove duplication
    local list = clipboard_history
    local result = {}
    local hashes = {}
    for i, v in ipairs(list) do
        if #result < hist_size then
            local hash = hashfn(v)
            if (not hashes[hash]) and hashfn(item) ~= hash then
                table.insert(result, v)
                hashes[hash] = true
            end
        end
    end
    table.insert(result, item)
    clipboard_history = result
end

function rerange_favorites_list(item)
    if item == nil or trim(item) == '' then
        return
    end
    table.insert(favorites, item)
    -- Remove duplication
    local list = favorites
    local result = {}
    local hashes = {}
    for i, v in ipairs(list) do
        if #result < hist_size then
            local hash = hashfn(v)
            if (not hashes[hash]) and hashfn(item) ~= hash then
                table.insert(result, v)
                hashes[hash] = true
            end
        end
    end
    table.insert(result, item)
    favorites = result
end

-- Dynamic menu by cmsj https://github.com/Hammerspoon/hammerspoon/issues/61#issuecomment-64826257
local makePopulatedMenuList = function(key)
    setTitle() -- Update the counter every time the menu is refreshed
    menuItems = {}
    local current_item = pasteboard.getContents()
    local source = current_item
    if (#clipboard_history == 0) then
        table.insert(menuItems, {
            title = "None",
            disabled = true
        }) -- If the history is empty, display "None"
    else
        for k, v in pairs(clipboard_history) do
            local quickAdd = {{
                title = "Favorite " .. string.format('`%s`', trim(#v > 50 and mb_substring(v, 0, 50) or v)),
                fn = function()
                    addToFavorite(v, key)
                end
            }}
            if (string.len(v) > label_length) then
                table.insert(menuItems, 1, {
                    title = hs.styledtext.new(trim(mb_substring(v, 0, label_length)) .. "…", {
                        font = {
                            size = 12
                        },
                        color = hs.drawing.color.definedCollections.hammerspoon.osx_green
                    }),
                    fn = function()
                        putOnPaste(v, key)
                    end,
                    tooltip = #v > tooltip_size and (mb_substring(v, 0, tooltip_size) .. "…") or v,
                    checked = current_item == v and true or false,
                    menu = quickAdd
                })
            else
                table.insert(menuItems, 1, {
                    title = trim(v),
                    fn = function()
                        putOnPaste(v, key)
                    end,
                    tooltip = #v > tooltip_size and (mb_substring(v, 0, tooltip_size) .. "…") or v,
                    checked = current_item == v and true or false,
                    menu = quickAdd
                })
            end
        end
    end
    table.insert(menuItems, {
        title = "-"
    })
    local favoriteList = {}
    table.insert(menuItems, 1, {
        title = "Favorites",
        menu = favoriteList
    })
    local favoritedItems = loadFavorites()
    for _, favorited in pairs(favoritedItems) do
        table.insert(favoriteList, {
            title = favorited,
            fn = function()
                putOnPaste(favorited, key)
            end,
            checked = current_item == favorited and true or false
        })
    end
    if #favoritedItems == 0 then
        table.insert(favoriteList, {
            title = "None",
            disabled = true
        })
    end
    if (key.alt == true) then
        table.insert(favoriteList, {
            title = "-"
        })
        table.insert(favoriteList, {
            title = "Delete All",
            fn = function()
                clearFavorites()
            end
        })
    end
    table.insert(menuItems, 2, {
        title = "-"
    })
    if type(current_item) == "string" then
        if (string.len(current_item) > label_length) then
            current_item = mb_substring(current_item, 0, label_length) .. "…"
        end
        if #trim(current_item) > 0 then
            table.insert(favoriteList, 1, {
                title = "Add " ..
                    string.format('`%s`', trim(#current_item > 50 and mb_substring(current_item, 0, 50) or current_item)) ..
                    " to Favorites",
                fn = function()
                    addToFavorite(current_item, key)
                end
            })
            table.insert(favoriteList, 2, {
                title = "-"
            })
        end
        table.insert(menuItems, 1, {
            title = "Current: " .. current_item,
            tooltip = #source > tooltip_size and (mb_substring(source, 0, tooltip_size) .. "…") or source,
            disabled = true
        })
    end
    table.insert(menuItems, {
        title = "Total Record(s): " .. #clipboard_history,
        disabled = true
    })
    if (key.alt == true) then
        table.insert(menuItems, {
            title = "-"
        })
        table.insert(menuItems, {
            title = "🗑 Delete All",
            fn = function()
                clearAll()
            end
        })
    end
    return menuItems
end

-- If the pasteboard owner has changed, we add the current item to our history and update the counter.
local function syncSysCopyboard()
    now = pasteboard.changeCount()
    if (now > last_change) then
        current_clipboard = pasteboard.getContents()
        -- asmagill requested this feature. It prevents the history from keeping items removed by password managers
        if (current_clipboard == nil and honor_clearcontent) then
            clearLastItem()
        else
            pasteboardToClipboard(current_clipboard)
        end
        last_change = now
    end
end

-- Checks for changes on the pasteboard. Is it possible to replace with eventtap?
timer = hs.timer.new(frequency, syncSysCopyboard)
timer:start()

setTitle() -- Avoid wrong title if the user already has something on his saved history
popboard:setMenu(makePopulatedMenuList)

hs.hotkey.bind({"cmd", "shift"}, "v", function()
    popboard:popupMenu(hs.mouse.absolutePosition(), true)
end)
