function ps.notify(source, text, type, time)
    if not source then return end
    if not text then return end
    if not type then type = 'info' end
    if not time then time = 5000 end
    TriggerClientEvent('esx:showNotification', source, text, type, time)
end