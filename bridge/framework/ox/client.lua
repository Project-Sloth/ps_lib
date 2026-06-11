local player = exports.ox_core:GetPlayer()

local function getPlayer()
    player = exports.ox_core:GetPlayer()
    return player
end

local function getGroupData(groupName, grade)
    if not groupName then return nil end

    local group = GlobalState[('group.%s'):format(groupName)] or {}
    local gradeLabel = group.grades and group.grades[grade]

    return {
        name = groupName,
        label = group.label or groupName,
        type = group.type or 'none',
        onduty = true,
        isboss = group.grades and grade == #group.grades or false,
        grade = {
            name = gradeLabel or tostring(grade or 0),
            level = grade or 0,
            payment = 0
        }
    }
end

local function loadPlayer()
    player = getPlayer()
    if not player then return end

    ps.ped = PlayerPedId()
    ps.charinfo = {
        firstname = player.get('firstName'),
        lastname = player.get('lastName'),
        birthdate = player.get('date'),
        gender = player.get('gender')
    }
    ps.citizenid = player.charId
    ps.identifier = player.stateId or player.charId
    ps.name = (ps.charinfo.firstname or '') .. ' ' .. (ps.charinfo.lastname or '')
end

AddEventHandler('ox:playerLoaded', loadPlayer)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        ps.ped = nil
        ps.charinfo = nil
        ps.citizenid = nil
        ps.identifier = nil
        ps.name = nil
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        loadPlayer()
    end
end)

function ps.getPlayerData()
    local oxPlayer = getPlayer()
    if not oxPlayer then return {} end

    local jobName, jobGrade = oxPlayer.getGroupByType('job')
    local gangName, gangGrade = oxPlayer.getGroupByType('gang')

    return {
        source = GetPlayerServerId(PlayerId()),
        citizenid = oxPlayer.charId,
        identifier = oxPlayer.stateId,
        charinfo = {
            firstname = oxPlayer.get('firstName'),
            lastname = oxPlayer.get('lastName'),
            birthdate = oxPlayer.get('date'),
            gender = oxPlayer.get('gender')
        },
        metadata = oxPlayer.getStatuses() or {},
        job = getGroupData(jobName, jobGrade),
        gang = getGroupData(gangName, gangGrade),
        money = ps.getMoneyData()
    }
end

function ps.getIdentifier()
    local oxPlayer = getPlayer()
    return oxPlayer and (oxPlayer.charId or oxPlayer.stateId)
end
ps.getCid = ps.getIdentifier

function ps.getMetadata(meta)
    local oxPlayer = getPlayer()
    if not oxPlayer then return nil end

    return oxPlayer.getStatus(meta) or oxPlayer.get(meta)
end

function ps.getCharInfo(info)
    local charinfo = ps.getPlayerData().charinfo or {}
    return charinfo[info]
end

function ps.getPlayerName()
    local charinfo = ps.getPlayerData().charinfo or {}
    return (charinfo.firstname or '') .. ' ' .. (charinfo.lastname or '')
end
ps.getName = ps.getPlayerName

function ps.getPlayer()
    return PlayerPedId()
end

function ps.getVehicleLabel(model)
    model = type(model) == 'number' and GetEntityModel(model) or model
    local vehicle = Ox and Ox.GetVehicleData and Ox.GetVehicleData(model)

    if vehicle and vehicle.name then
        return vehicle.name
    end

    return GetDisplayNameFromVehicleModel(model)
end

function ps.isDead()
    return LocalPlayer.state.isDead or false
end

function ps.getJob()
    return ps.getPlayerData().job
end

function ps.getJobName()
    local job = ps.getJob()
    return job and job.name or 'unemployed'
end

function ps.getJobType()
    local job = ps.getJob()
    return job and job.type or 'none'
end

function ps.isBoss()
    local job = ps.getJob()
    return job and job.isboss or false
end

function ps.getJobDuty()
    local job = ps.getJob()
    return job and job.onduty or false
end

function ps.getJobData(data)
    local job = ps.getJob()
    return job and job[data]
end

function ps.getGang()
    return ps.getPlayerData().gang
end

function ps.getGangName()
    local gang = ps.getGang()
    return gang and gang.name or 'none'
end

function ps.isLeader()
    local gang = ps.getGang()
    return gang and gang.isboss or false
end

function ps.getGangData(data)
    local gang = ps.getGang()
    return gang and gang[data]
end

function ps.getCoords()
    return GetEntityCoords(ps.ped or PlayerPedId())
end

function ps.getMoneyData()
    return {
        cash = 0,
        bank = 0
    }
end

function ps.getMoney(type)
    return ps.getMoneyData()[type or 'cash'] or 0
end

function ps.getAllMoney()
    local moneyData = {}
    for k, v in pairs(ps.getMoneyData()) do
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
