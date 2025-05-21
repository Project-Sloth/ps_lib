
if Config.Framework ~= 'qb' then return end
ps.debug('Loading QBCore Framework')
if IsDuplicityVersion() then
    function ps.getPlayer(source)
        return QBCore.Functions.GetPlayer(source)
    end
    function ps.getPlayerByIdentifier(identifier)
        return QBCore.Functions.GetPlayerByCitizenId(identifier)
    end
    function ps.getOfflinePlayer(identifier)
        return QBCore.Functions.GetOfflinePlayerByCitizenId(identifier)
    end
    function ps.getIdentifier(source)
        local player = ps.getPlayer(source)
        return player.PlayerData.citizenid
    end
    function ps.getPlayerName(source)
        local player = ps.getPlayer(source)
        return player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
    end
    function ps.getPlayerNameByIdentifier(identifier)
        local player = ps.getPlayerByIdentifier(identifier)
        return player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
    end
    function ps.getPlayerData(source)
        local player = ps.getPlayer(source)
        return player.PlayerData
    end
    function ps.getMetadata(source, meta)
        local player = ps.getPlayer(source)
        return player.PlayerData.metadata[meta]
    end
    function ps.getCharInfo(source, info)
        local player = ps.getPlayer(source)
        return player.PlayerData.charinfo[info]
    end
    function ps.getJob(source)
        local player = ps.getPlayer(source)
        return player.PlayerData.job
    end
    function ps.getJobName(source)
        local player = ps.getPlayer(source)
        return player.PlayerData.job.name
    end
    function ps.getJobType(source)
        local player = ps.getPlayer(source)
        return player.PlayerData.job.type
    end
    function ps.getJobDuty(source)
        local player = ps.getPlayer(source)
        return player.PlayerData.job.onduty
    end
    function ps.getJobData(source, data)
        local player = ps.getPlayer(source)
        return player.PlayerData.job[data]
    end
    function ps.isBoss(source)
        local player = ps.getPlayer(source)
        return player.PlayerData.job.isboss
    end

    function ps.getAllPlayers()
        return QBCore.Functions.GetPlayers()
    end
    function ps.getDistance(source, location)
        local pcoords = GetEntityCoords(GetPlayerPed(source))
        local loc = vector3(location.x, location.y, location.z)
        return #(pcoords - loc)
    end
    function ps.getNearbyPlayers(source, distance) 
        if not distance then distance = 10.0 end
        local players = {}
        for k, v in pairs(ps.getAllPlayers()) do
            local dist = #(GetEntityCoords(GetPlayerPed(v)) - GetEntityCoords(GetPlayerPed(source)))
            if dist < 5.0 then
                table.insert(players, {
                    id = ps.getIdentifier(v),
                    name = ps.getPlayerName(v),
                    source = v,
                    distance = dist,
                })
            end
        end
        return players
    end
    function ps.createUseable(item, func)
        if not item or not func then return end
        QBCore.Functions.CreateUseableItem(item, func)
    end
else
    function ps.getPlayerData()
        return QBCore.Functions.GetPlayerData()
    end

    function ps.getIdentifier()
        return ps.getPlayerData().citizenid
    end

    function ps.getMetadata(meta)
        return ps.getPlayerData().metadata[meta]
    end

    function ps.getCharInfo(info)
        return ps.getPlayerData().charinfo[info]
    end

    function ps.getPlayerName()
        local player = ps.getPlayerData()
        return player.charinfo.firstname .. " " .. player.charinfo.lastname
    end

    function ps.getPlayer()
        return PlayerPedId()
    end

    function ps.getVehicleLabel(model)
        model = GetEntityModel(model)
        local vehicle = QBCore.Shared.Vehicles[model]
        if vehicle then
            return vehicle.name
        else
            return GetDisplayNameFromVehicleModel(model)
        end
    end

    function ps.isDead()
        if ps.getMetadata('isdead') or ps.getMetadata('inlaststand') then
            return true
        else
            return false
        end
    end

    function ps.getJob()
        local player = ps.getPlayerData()
        return player.job
    end

    function ps.getJobName()
        local job = ps.getJob()
        return job.name
    end

    function ps.getJobType()
        local job = ps.getJob()
        return job.type
    end

    function ps.isBoss()
        local job = ps.getJob()
        return job.isboss
    end

    function ps.getJobDuty()
        local job = ps.getJob()
        return job.onduty
    end

    function ps.getJobData(data)
        local job = ps.getJob()
        return job[data]
    end

    function ps.getGang()
        local player = ps.getPlayerData()
        return player.job
    end

    function ps.getGangName()
        local job = ps.getGang()
        return job.name
    end

    function ps.isBoss()
        local Gang = ps.getGang()
        return Gang.isboss
    end

    function ps.getGangDuty()
        local Gang = ps.getGang()
        return Gang.onduty
    end

    function ps.getGangData(data)
        local Gang = ps.getGang()
        return Gang[data]
    end
end