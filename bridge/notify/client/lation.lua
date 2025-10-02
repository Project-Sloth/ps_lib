
function ps.notify(text, type, time)
    if not text then return end
    if not type then type = 'info' end
    if not time then time = 5000 end
    exports.lation_ui:notify({
        message = text,
        type = type,
        duration = time
    })
end

RegisterNetEvent('ps_lib:notify:lation', function(data)
    ps.notify(data.message, data.type, data.duration)
end)

exports('notify', ps.notify)