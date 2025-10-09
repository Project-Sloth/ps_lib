ps.success('Notification Module Loaded: ox_lib Notify')
function ps.notify(text, type, time)
    if not text then return end
    if not type then type = 'info' end
    if not time then time = 5000 end
    lib.notify({
        description = text,
        type = type,
        duration = time,
    })
end

exports('notify', ps.notify)