ps.success('Notification Module Loaded: V42 Notify')
function ps.notify(text, type, time)
    if not text then return end
    if not type then type = 'info' end
    if not time then time = 5000 end
    exports['v42-notify']:notify(text, type, time)
end

RegisterNetEvent('ps_lib:notify:v42', function(data)
    ps.notify(data.message, data.type, data.duration)
end)

exports('notify', ps.notify)