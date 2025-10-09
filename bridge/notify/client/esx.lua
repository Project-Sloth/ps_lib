ps.success('Notification Module Loaded: ESX Notify')
function ps.notify( text, type, time)
    if not text then return end
    if not type then type = 'info' end
    if not time then time = 5000 end
    ESX.ShowNotification(text, type, time, "Notification", "top-left")
end
exports('notify', ps.notify)