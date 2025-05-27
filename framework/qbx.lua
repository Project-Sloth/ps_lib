
if Config.Framework ~= 'qbx' then return end
ps.debug('Loading QBX Framework')
if IsDuplicityVersion() then
    function ps.getPlayer(source)
        return qbx:GetPlayer(source)
    end

    function ps.getPlayerByIdentifier(identifier)
        return qbx:GetPlayerByCitizenId(identifier)
    end

    function ps.getOfflinePlayer(identifier)
        return qbx:GetOfflinePlayerByCitizenId(identifier)
    end

    function ps.getIdentifier(source)
        local player = ps.getPlayer(source)
        return player.PlayerData.citizenid
    end

    function ps.getPlayerName(source)
        local player = ps.getPlayer(source)
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

    function ps.getJobGrade(source)
        local player = ps.getPlayer(source)
        return player.PlayerData.job.grade
    end

    function ps.getJobGradeName(source)
        local player = ps.getPlayer(source)
        return player.PlayerData.job.grade.name
    end
    
    function ps.getJobGradePay(source)
        local player = ps.getPlayer(source)
        return player.PlayerData.job.grade.payment
    end

    function ps.isBoss(source)
        local player = ps.getPlayer(source)
        return player.PlayerData.job.isboss
    end

    function ps.getAllPlayers()
        return qbx:GetPlayers()
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
      function ps.getJobCount(jobName)
        local count = 0
        for _, player in pairs(ps.getAllPlayers()) do
            local playerData = ps.getPlayerData(player)
            if playerData.job and playerData.job.name == jobName and ps.getJobDuty(player) then
                count = count + 1
            end
        end
        return count
    end

    function ps.getJobTypeCount(jobName)
        local count = 0
        for _, player in pairs(ps.getAllPlayers()) do
            local playerData = ps.getPlayerData(player)
            if playerData.job and playerData.job.type == jobName and ps.getJobDuty(player) then
                count = count + 1
            end
        end
        return count
    end

    function ps.createUseable(item, func)
        if not item or not func then return end
        qbx:CreateUseableItem(item, func)
    end
else
    function ps.getPlayerData()
        return QBX.PlayerData
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
        if not IsPedInAnyVehicle(ps.getPlayer(), false) then
            return false
        end
        model = GetEntityModel(model)
        local vehicle = exports.qbx_core:GetVehiclesByName(model)
        if vehicle then
            return vehicle.name
        else
            return GetDisplayNameFromVehicleModel(model)
        end
    end

    function ps.isDead()
        local isDead = exports.qbx_medical:IsDead()
        local inLaststand = exports.qbx_medical:IsLaststand()
        if isDead or inLaststand then return true end
        return false
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