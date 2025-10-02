function ps.notify(text, type, time)
    if not text then return end
    if not type then type = 'info' end
    if not time then time = 5000 end
    exports['paradise_notify']:ShowNotification({
    description = text,
    type = type,
    duration = time,
})
end

exports('notify', ps.notify)