

function ps.notify(source, text, type, time)
    if not source then return end
    if not text then return end
    if not type then type = 'info' end
    if not time then time = 5000 end
    if Config.Notify == 'qb' then
        TriggerClientEvent('QBCore:Notify', source, text, type, time)
    elseif Config.Notify == 'esx' then
        TriggerClientEvent('esx:showNotification', source, text, type, time)
    elseif Config.Notify == 'ps' then
        TriggerClientEvent('ps_lib:notify', source, text, type, time)
    elseif Config.Notify == 'ox' then
        TriggerClientEvent('ox_lib:notify', source, {
            description = text,
            type = type,
            duration = time,
        })
    elseif Config.Notify == 'mad_thoughts' then
        if type == 'error' then
            exports['mad-thoughts']:error(source, text, time / 1000)
        elseif type == 'success' then
            exports['mad-thoughts']:success(source, text, time / 1000)
        elseif type == 'info' then
            exports['mad-thoughts']:info(source, text, time / 1000)
        elseif type == 'warning' then
            exports['mad-thoughts']:warning(source, text, time / 1000)
        end
    end
end