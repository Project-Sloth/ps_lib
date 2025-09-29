
function ps.notify(text, type, time)
    if not text then return end
    if not type then type = 'info' end
    if not time then time = 5000 end
    QBCore.Functions.Notify(text, type, time)
end