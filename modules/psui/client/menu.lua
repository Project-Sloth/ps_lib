local storedData = nil
local count = 0
---Creates a menu and registers its events.
---@param menuData table: Data for the menu, including items and submenus.
local function createMenu(menuData)
    for k, item in pairs(menuData) do
        menuData[k].id = k
    end
    storedData = menuData
    SendNUI("ShowMenu", nil, {
        menuData = menuData
    }, true)
end

--- Event handler for creating a menu from a network event.
--- @param menuData table: Data for the menu, including items and submenus.
RegisterNetEvent("ps-ui:CreateMenu", function(menuData)
    if not menuData then
        return
    end

    createMenu(menuData)
end)

--- Closes the current menu.
local function hideMenu()
    SendNUI("HideMenu", nil, {}, false)
    storedData = nil
end

--- NUI callback for closing the menu.
--- @param data any: Data from the NUI (not used in this function).
--- @param cb function: Callback function to signal completion of the NUI callback.
RegisterNUICallback('menuClose', function(data, cb)
    SetNuiFocus(false, false)
    storedData = nil
    cb('ok')
end)

--- NUI callback for menu item selection.
--- @param data table: Data from the NUI, including event details.
--- @param cb function: Callback function to signal completion of the NUI callback. The callback should be called with a string status, e.g., 'ok' or an error message.
RegisterNUICallback('MenuSelect', function(data, cb)
    count = count + 1
    ps.debug('count', count)
    TriggerEvent("ps-menu:doThings", data)
    cb('ok')
end)

RegisterNetEvent("ps-menu:doThings", function(data) 
    SetNuiFocus(false, false)
    local menuData = storedData[data]
    storedData = nil
    ps.debug(menuData)
    if menuData.action then
        Wait(100)
        menuData.action()
    end
    if menuData.server then
        TriggerServerEvent(menuData.event, table.unpack(menuData.args))
    end
    if menuData.event and not menuData.server then
        TriggerEvent(menuData.event, table.unpack(menuData.args))
    end
    SetNuiFocus(false, false)
end)

exports("CreateMenu", createMenu)
exports("HideMenu", hideMenu)
ps.exportChange('ps-ui', "CreateMenu", createMenu)
ps.exportChange('ps-ui', "HideMenu", hideMenu)