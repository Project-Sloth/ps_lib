qbx = exports.qbx_core

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