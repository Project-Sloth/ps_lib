function ps.notify(source, text, type, time)
    if not source then return end
    if not text then return end
    if not type then type = 'info' end
    if not time then time = 5000 end
    if Config.Notify == 'qb' then
        TriggerClientEvent('QBCore:Notify', source, text, type, time)
    elseif Config.Notify == 'esx' then
        TriggerClientEvent('esx:showNotification', source, text, type, time)
    elseif Config.Notify == 'ox' then
        TriggerClientEvent('ox_lib:notify', source, {
            description = text,
            type = type,
            duration = time,
        })
    end
    return {source, text, type, time}
end

RegisterCommand('testServer', function(source, args, rawCommand)
    local src = source
    local id = ps.getIdentifier(src)
    local table = {
        --player = ps.getPlayer(src),
        --Id = ps.getIdentifier(src),
        --pbyId = ps.getPlayerByIdentifier(id),
        --offline = ps.getOfflinePlayer(id),
        --sour = ps.getSource(id),
        --name = ps.getPlayerName(src),
        --nameByID = ps.getPlayerNameByIdentifier(id),
        --data = ps.getPlayerData(src),
        meta = ps.getMetadata(src, 'hunger'),
        char = ps.getCharInfo(src, 'birthdate'),
        job = ps.getJob(src),
        jobName = ps.getJobName(src),
        jobDuty = ps.getJob(src).onDuty,
    }
    ps.debug('Server Command', table)
end, false)