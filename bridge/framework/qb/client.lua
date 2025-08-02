local QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    ps.ped = PlayerPedId()
    ps.charinfo = QBCore.Functions.GetPlayerData().charinfo
    ps.citizenid = QBCore.Functions.GetPlayerData().citizenid
    ps.name = ps.charinfo.firstname .. " " .. ps.charinfo.lastname
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        ps.ped = nil
        ps.charinfo = nil
        ps.citizenid = nil
        ps.name = nil
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if PlayerPedId() then
            ps.ped = PlayerPedId()
            ps.charinfo = QBCore.Functions.GetPlayerData().charinfo
            ps.citizenid = QBCore.Functions.GetPlayerData().citizenid
            ps.name = ps.charinfo.firstname .. " " .. ps.charinfo.lastname
        end
    end
end)

---@return: table
---@DESCRIPTION: Returns the player's data, including job, gang, and metadata.
function ps.getPlayerData()
    return QBCore.Functions.GetPlayerData()
end

--- @return: string
--- @DESCRIPTION: Returns the player's citizen ID.
--- @example: ps.getIdentifier()
function ps.getIdentifier()
    return ps.getPlayerData().citizenid
end
ps.getCid = ps.getIdentifier
--- @PARAM: meta: string
--- @return: any
--- @DESCRIPTION: Returns specific metadata for the player.
--- @example: ps.getMetadata('isdead')
function ps.getMetadata(meta)
    return ps.getPlayerData().metadata[meta]
end

--- @PARAM: info: string
--- @return: any
--- @DESCRIPTION: Returns specific character information based on the provided key.
--- @example: ps.getCharInfo('age')
function ps.getCharInfo(info)
    return ps.getPlayerData().charinfo[info]
end

--- @return: string
--- @DESCRIPTION: Returns the player's full name.
function ps.getPlayerName()
    return ps.getPlayerData().charinfo.firstname .. " " .. ps.getPlayerData().charinfo.lastname
end
ps.getName = ps.getPlayerName
--- @return: number
--- @DESCRIPTION: Returns the player's ped ID.
function ps.getPlayer()
    return PlayerPedId()
end

--- @PARAM: model: number | string
--- @RETURN: string
--- @DESCRIPTION: Returns the vehicle label for the given model.
function ps.getVehicleLabel(model)
    model = GetEntityModel(model)
    local vehicle = QBCore.Shared.Vehicles[model]

    if vehicle then
        return vehicle.name
    else
        return GetDisplayNameFromVehicleModel(model)
    end
end

--- @DESCRIPTION: Checks if the player is dead or in last stand.
--- @return boolean
--- @example if ps.isDead() then Revive end
function ps.isDead()
    if ps.getMetadata('isdead') or ps.getMetadata('inlaststand') then
        return true
    else
        return false
    end
end

--- @return: table
--- @DESCRIPTION: Returns the player's job information, including name, type, and duty status.
function ps.getJob()
    local player = ps.getPlayerData()
    return player.job
end

--- @RETURN: string
--- @DESCRIPTION: Returns the name of the player's job.
--- @example: ps.getJobName()
function ps.getJobName()
    local job = ps.getJob()
    return job.name
end

--- @RETURN: string
--- @DESCRIPTION: Returns the type of the player's job.
--- @example: ps.getJobType()
function ps.getJobType()
    local job = ps.getJob()
    return job.type
end

--- @RETURN: boolean
--- @DESCRIPTION: Checks if the player's job is a boss job.
--- @example: if ps.isBoss() then TriggerEvent('qb-bossmenu:client:openMenu') end
function ps.isBoss()
    local job = ps.getJob()
    return job.isboss
end

--- @RETURN: boolean
--- @DESCRIPTION: Checks if the player is on duty for their job.
--- @example: if ps.getJobDuty() then TriggerEvent('qb-phone:client:openJobPhone') end
function ps.getJobDuty()
    local job = ps.getJob()
    return job.onduty
end

--- @PARAM: data: string
--- @RETURN: any
--- @DESCRIPTION: Returns the job data for the specified key.
function ps.getJobData(data)
    local job = ps.getJob()
    return job[data]
end

--- @return: table
--- @DESCRIPTION: Returns the player's gang information, including name, type, and duty status.
--- @example: ps.getGang()

function ps.getGang()
    local player = ps.getPlayerData()
    return player.gang
end

--- @RETURN: string
--- @DESCRIPTION: Returns the name of the player's gang.
--- @example: ps.getGangName()
function ps.getGangName()
    local job = ps.getGang()
    return job.name
end

--- @RETURN: string
--- @DESCRIPTION: Returns if the player is a gang boss.
--- @example: ps.isLeader()
function ps.isLeader()
    local Gang = ps.getPlayerData().gang.isboss
    return Gang
end


--- @PARAM: data: string
--- @RETURN: any
--- @DESCRIPTION: Returns specific data from the gang information.
function ps.getGangData(data)
    local Gang = ps.getGang()
    return Gang[data]
end

--- @RETURN: boolean
--- @DESCRIPTION: Checks the coords of the player.
--- @example: if ps.getCoords() then  end

function ps.getCoords()
    return GetEntityCoords(ps.ped)
end

function ps.getMoneyData()
    local money = QBCore.Functions.GetPlayerData().money
    return money
end
function ps.getMoney(type)
    local money = QBCore.Functions.GetPlayerData().money
    return money[type] or 0
end

function ps.getAllMoney()
    local money = QBCore.Functions.GetPlayerData().money
    local moneyData = {}
    for k, v in pairs(money) do
       table.insert(moneyData, {
            amount = v,
            name = k
        })
    end
    return moneyData
end

exports('getPlayerData', ps.getPlayerData)
exports('getIdentifier', ps.getIdentifier)
exports('getCid', ps.getCid)
exports('getMetadata', ps.getMetadata)
exports('getCharInfo', ps.getCharInfo)
exports('getPlayerName', ps.getPlayerName)
exports('getName', ps.getName)
exports('getPlayer', ps.getPlayer)
exports('getVehicleLabel', ps.getVehicleLabel)
exports('isDead', ps.isDead)
exports('getJob', ps.getJob)
exports('getJobName', ps.getJobName)
exports('getJobType', ps.getJobType)
exports('isBoss', ps.isBoss)
exports('getJobDuty', ps.getJobDuty)
exports('getJobData', ps.getJobData)
exports('getGang', ps.getGang)
exports('getGangName', ps.getGangName)
exports('isLeader', ps.isLeader)
exports('getGangData', ps.getGangData)
exports('getCoords', ps.getCoords)
exports('getMoneyData', ps.getMoneyData)
exports('getMoney', ps.getMoney)
exports('getAllMoney', ps.getAllMoney)