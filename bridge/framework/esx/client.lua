
local esxJOBCompat = {
    ['police'] = 'leo',
    ['unemployed'] = 'loser'
}
local health, armor, thirst, hunger,stress = 0, 0, 0, 0,0

local esxMetadata = {
    health = health,
    armor = armor,
    thirst = thirst,
    hunger = hunger,
    stress = stress,
}

AddEventHandler("esx:playerLoaded", function()
    local playerData = ESX.GetPlayerData()
    ps.ped = PlayerPedId()
    ps.charinfo = {
        firstname = playerData.firstName,
        lastname = playerData.lastName,
        age = playerData.dateofbirth,
        gender = playerData.sex
    }
    ps.name = playerData.firstName .. " " .. playerData.lastName
    ps.identifier = playerData.identifier
end)
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
         local playerData = ESX.GetPlayerData()
        ps.ped = PlayerPedId()
        ps.charinfo = {
            firstname = playerData.firstName,
            lastname = playerData.lastName,
            age = playerData.dateofbirth,
            gender = playerData.sex
        }
                ps.name = playerData.firstName .. " " .. playerData.lastName
        ps.identifier = playerData.identifier
    end
end)
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        ps.ped = nil
        ps.charinfo = nil
        ps.name = nil
        ps.identifier = nil
    end
end)
AddEventHandler("esx_status:onTick", function(data)
    local hunger, thirst, stress 
    for i = 1, #data do
        if data[i].name == "thirst" then
            thirst = math.floor(data[i].percent)
        end
        if data[i].name == "hunger" then
            hunger = math.floor(data[i].percent)
        end
        if data[i].name == "stress" then
            stress = math.floor(data[i].percent)
        end
    end
    esxMetadata.health = math.floor((GetEntityHealth(ESX.PlayerData.ped) - 100) / 100 * 100)
    esxMetadata.armor = GetPedArmour(ESX.PlayerData.ped)
    esxMetadata.thirst = thirst
    esxMetadata.hunger = hunger
    esxMetadata.stress = stress
end)
---@return: table
---@DESCRIPTION: Returns the player's data, including job, gang, and metadata.
function ps.getPlayerData()
    return ESX.PlayerData
end

--- @return: string
--- @DESCRIPTION: Returns the player's citizen ID.
--- @example: ps.getIdentifier()
function ps.getIdentifier()
    return ps.getPlayerData().identifier
end

--- @PARAM: meta: string
--- @return: any
--- @DESCRIPTION: Returns specific metadata for the player.
--- @example: ps.getMetadata('isdead')
function ps.getMetadata(meta)
    if esxMetadata[meta] ~= nil then
        return esxMetadata[meta]
    end
    if meta == 'isdead' then
        return ESX.PlayerData.dead
    end
    return ps.getPlayerData().metadata[meta]
end

--- @PARAM: info: string
--- @return: any
--- @DESCRIPTION: Returns specific character information based on the provided key.
--- @example: ps.getCharInfo('age')
function ps.getCharInfo(info)
    return ps.charinfo[info]
end

--- @return: string
--- @DESCRIPTION: Returns the player's full name.
function ps.getPlayerName()
    return ps.name
end

--- @return: number
--- @DESCRIPTION: Returns the player's ped ID.
function ps.getPlayer()
    return PlayerPedId()
end

--- @PARAM: model: number | string
--- @RETURN: string
--- @DESCRIPTION: Returns the vehicle label for the given model.
function ps.getVehicleLabel(model)
    local vehicle = ps.callback('ps_lib:esx:getVehicleLabel', model)
    return vehicle or GetDisplayNameFromVehicleModel(model)
end
   

--- @DESCRIPTION: Checks if the player is dead or in last stand.
--- @return boolean
--- @example if ps.isDead() then Revive end
function ps.isDead()
   return ESX.PlayerData.dead
end

--- @return: table
--- @DESCRIPTION: Returns the player's job information, including name, type, and duty status.
function ps.getJob()
   return ESX.PlayerData.job
end

--- @RETURN: string
--- @DESCRIPTION: Returns the name of the player's job.
--- @example: ps.getJobName()
function ps.getJobName()
    return ps.getJob()['name']
end

--- @RETURN: string
--- @DESCRIPTION: Returns the type of the player's job.
--- @example: ps.getJobType()
function ps.getJobType()
    return esxJOBCompat[ps.getJob().name] or 'none'
end

--- @RETURN: boolean
--- @DESCRIPTION: Checks if the player's job is a boss job.
--- @example: if ps.isBoss() then TriggerEvent('qb-bossmenu:client:openMenu') end
function ps.isBoss()
    return ps.getJob().grade_name == 'boss'
end

--- @RETURN: boolean
--- @DESCRIPTION: Checks if the player is on duty for their job.
--- @example: if ps.getJobDuty() then TriggerEvent('qb-phone:client:openJobPhone') end
function ps.getJobDuty()
    return ps.getJob().onDuty
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
    return player.job
end

--- @RETURN: string
--- @DESCRIPTION: Returns the name of the player's gang.
--- @example: ps.getGangName()
--- @
--- @-- Does esx support Gangs?
--function ps.getGangName()
--    local job = ps.getGang()
--    return job.name
--end

--- @RETURN: string
--- @DESCRIPTION: Returns if the player is a gang boss.
--- @example: ps.isLeader()
--function ps.isLeader()
--    local Gang = ps.getGang()
--    return Gang.isboss
--end


--- @PARAM: data: string
--- @RETURN: any
--- @DESCRIPTION: Returns specific data from the gang information.
--function ps.getGangData(data)
--    local Gang = ps.getGang()
--    return Gang[data]
--end

--- @RETURN: boolean
--- @DESCRIPTION: Checks the coords of the player.
--- @example: if ps.getCoords() then  end
function ps.getCoords()
    return GetEntityCoords(ps.ped)
end

function ps.getMoneyData()
    local money = {
        cash = ESX.PlayerData.money,
        bank = ESX.GetAccount('bank'),
    }
    return money
end
function ps.getMoney(type)
    return ps.getMoneyData()[type] or 0
end

function ps.getAllMoney()
    local money = ps.getMoneyData()
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
exports('getMetadata', ps.getMetadata)
exports('getCharInfo', ps.getCharInfo)
exports('getPlayerName', ps.getPlayerName)
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
exports('defaultDuty', ps.defaultDuty)
exports('isLeader', ps.isLeader)
exports('getGangData', ps.getGangData)
exports('getCoords', ps.getCoords)
exports('getMoneyData', ps.getMoneyData)
exports('getMoney', ps.getMoney)
exports('getAllMoney', ps.getAllMoney)