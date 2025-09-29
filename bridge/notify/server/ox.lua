function ps.notify(source, text, type, time)
    if not source then return end
    if not text then return end
    if not type then type = 'info' end
    if not time then time = 5000 end
    TriggerClientEvent('ox_lib:notify', source, {
        description = text,
        type = type,
        duration = time,
    })
end