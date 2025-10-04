
function ps.notify(src, text, type, time)
    if not src then return end
    if not text then return end
    if not type then type = 'info' end
    if not time then time = 5000 end
    TriggerClientEvent('okokNotify:Alert', src, '', text, time, type, false)
end
exports('notify', ps.notify)