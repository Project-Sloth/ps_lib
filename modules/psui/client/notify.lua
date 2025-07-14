

RegisterNUICallback('hideUI', function(_, cb)
    cb({})
    SetNuiFocus(false, false)
end)

function sendNotification(message, type, duration)
    if not message then return end
    if not type then type = 'info' end
    if not duration then duration = 5000 end
    SendNUIMessage({
        action = 'notify',
        data = {
            message = message,
            type = type,
            duration = duration
        }
    })
end
exports('notify', sendNotification)
ps.exportChange('ps-ui', 'notify', sendNotification)

RegisterCommand('testNotify', function()
    exports['ps-ui']:notify('This is a test notification!', 'success', 3000)
    exports['ps-ui']:notify('This is a test notification!', 'error', 3000)
    exports['ps-ui']:notify('This is a test notification!', 'info', 3000)
    exports['ps-ui']:notify('C\nH\nE\nE\nS\nE\nB\nU\nR\nG\nE\nR \n \n A\nP\nO\nC\nA\nL\nY\nP\nS\nE', 'warning', 3000)
    
end)
