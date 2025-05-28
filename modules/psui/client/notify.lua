--- Sends a notification to the user.
--- @param text string: The text content of the notification.
--- @param type string|nil: The type of notification (e.g., 'primary', 'success', 'error'). Defaults to 'primary' if nil.
--- @param length number|nil: Duration of the notification in milliseconds. Defaults to 5000 milliseconds (5 seconds) if nil.
local function notify(text, type, length)
    type = type or 'primary'  -- Default to 'primary' if type is nil
    length = length or 5000  -- Default to 5000 milliseconds if length is nil
    ps.debug("Notify called with " .. text .. " text and " .. type .. " type")
    SendNUI("ShowNotification", nil, {
        text = text,       -- Notification text
        type = type,       -- Notification type
        length = length    -- Duration of the notification
    }, false)
end

--- Network event handler for sending a notification.
RegisterNetEvent('ps-ui:Notify', notify)

exports('Notify', notify)
ps.exportChange('ps-ui', "Notify", notify)
CreateThread(function()
    Wait(2000)
    notify("PS-UI is loaded", "success", 1000)
    Wait(1200)
    notify('test', 'warning', 1000) -- Example notification for testing
    Wait(1200)
    notify('This is a primary notification', 'error', 1000) -- Example notification for testing
    Wait(1200)
    notify('This is a success notification', 'info', 1000) -- Example notification for testing
    Wait(1200)
    notify('This is a mint notification', 'primary', 5000) -- Example mint notification
end)