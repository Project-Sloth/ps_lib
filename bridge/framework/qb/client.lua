local QBCore = exports['qb-core']:GetCoreObject()


ps.citizenid = QBCore.Functions.GetPlayerData().citizenid
ps.charinfo = QBCore.Functions.GetPlayerData().charinfo
ps.ped = PlayerPedId()
ps.name = QBCore.Functions.GetPlayerData().charinfo.firstname .. " " .. QBCore.Functions.GetPlayerData().charinfo.lastname


function ps.getPlayerData()
    return QBCore.Functions.GetPlayerData()
end

function ps.getIdentifier()
    return ps.citizenid
end

function ps.getMetadata(meta)
    return ps.getPlayerData().metadata[meta]
end

function ps.getCharInfo(info)
    return ps.charinfo[info]
end

function ps.getPlayerName()
    return ps.name
end

function ps.getPlayer()
    return ps.ped
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

function ps.isLeader()
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