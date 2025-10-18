function ps.notify(source, text, type, time)
    if not source then return end
    if not text then return end
    if not type then type = 'info' end
    if not time then time = 5000 end
    TriggerClientEvent('ps_lib:notify:v42', source, {
        message = text,
        type = type,
        duration = time,
    })
end

exports('notify', ps.notify)
ps.success('Notification Module Loaded: V42 Notify')