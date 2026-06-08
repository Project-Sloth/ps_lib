local function getPlayer(source)
    source = tonumber(source)
    if not source then return nil end

    return exports.ox_core:GetPlayer(source)
end

local function oxExport(name, ...)
    local ok, result = pcall(function(...)
        return exports.ox_core[name](exports.ox_core, ...)
    end, ...)

    if ok then return result end
end

local function getGroup(groupName)
    if not groupName then return nil end
    return oxExport('GetGroup', groupName)
end

local function getGroupState(groupName)
    return groupName and GlobalState[('group.%s'):format(groupName)] or nil
end

local function formatGroup(groupName, grade)
    if not groupName then return nil end

    local group = getGroup(groupName) or getGroupState(groupName) or {}
    local grades = group.grades or {}
    local gradeData = grades[grade] or grades[tostring(grade)] or {}
    local gradeName = type(gradeData) == 'table' and (gradeData.name or gradeData.label) or gradeData

    return {
        name = groupName,
        label = group.label or groupName,
        type = group.type or 'none',
        onduty = true,
        isboss = grade == #grades,
        grade = {
            name = gradeName or tostring(grade or 0),
            level = grade or 0,
            payment = type(gradeData) == 'table' and gradeData.payment or 0
        }
    }
end

local function getPrimaryGroup(player, groupType)
    if not player then return nil end

    local groupName, grade = player.getGroupByType(groupType)
    return formatGroup(groupName, grade)
end

local function getPlayerByAny(value)
    return ps.getPlayer(value) or ps.getPlayerByIdentifier(value) or ps.getOfflinePlayer(value)
end

function ps.getPlayer(source)
    return getPlayer(source)
end

function ps.getPlayerByIdentifier(identifier)
    local charId = tonumber(identifier)
    return charId and exports.ox_core:GetPlayerFromCharId(charId) or exports.ox_core:GetPlayerFromFilter({ stateId = identifier })
end
ps.getPlayerByCid = ps.getPlayerByIdentifier

function ps.getOfflinePlayer(identifier)
    local charId = tonumber(identifier)
    return charId and exports.ox_core:GetPlayerFromCharId(charId) or exports.ox_core:GetPlayerFromFilter({ stateId = identifier })
end

function ps.getLicense(source)
    if GetConvarInt('sv_fxdkMode', 0) == 1 then return 'license:fxdk' end
    return GetPlayerIdentifierByType(source, 'license')
end

function ps.getIdentifier(source)
    local player = ps.getPlayer(source)
    return player and (player.charId or player.stateId)
end
ps.getCid = ps.getIdentifier

function ps.getSource(identifier)
    local player = ps.getPlayerByIdentifier(identifier)
    return player and player.source or nil
end

function ps.getPlayerName(source)
    local player = getPlayerByAny(source)
    if not player then return 'Unknown Person' end

    local firstName = player.get('firstName') or ''
    local lastName = player.get('lastName') or ''
    local name = (firstName .. ' ' .. lastName):gsub('^%s*(.-)%s*$', '%1')

    return name ~= '' and name or player.username or 'Unknown Person'
end
ps.getName = ps.getPlayerName

function ps.getPlayerNameByIdentifier(identifier)
    return ps.getPlayerName(identifier)
end
ps.getPlayerNameByCid = ps.getPlayerNameByIdentifier

function ps.getPlayerData(source)
    local player = getPlayerByAny(source)
    if not player then return nil end

    return {
        source = player.source,
        citizenid = player.charId,
        identifier = player.stateId,
        charinfo = {
            firstname = player.get('firstName'),
            lastname = player.get('lastName'),
            birthdate = player.get('date'),
            gender = player.get('gender')
        },
        metadata = player.getStatuses() or {},
        job = getPrimaryGroup(player, 'job'),
        gang = getPrimaryGroup(player, 'gang')
    }
end

function ps.getMetadata(source, meta)
    local player = getPlayerByAny(source)
    if not player then return nil end

    return player.getStatus(meta) or player.get(meta)
end

function ps.getCharInfo(source, info)
    local playerData = ps.getPlayerData(source)
    return playerData and playerData.charinfo and playerData.charinfo[info]
end

function ps.getJob(source)
    local player = getPlayerByAny(source)
    return getPrimaryGroup(player, 'job')
end

function ps.getJobName(source)
    local job = ps.getJob(source)
    return job and job.name or 'unemployed'
end

function ps.getJobType(source)
    local job = ps.getJob(source)
    return job and job.type or 'none'
end

function ps.getJobDuty(source)
    local job = ps.getJob(source)
    return job and job.onduty or false
end

function ps.getJobData(source, data)
    local job = ps.getJob(source)
    return job and job[data]
end

function ps.getJobGrade(source)
    local job = ps.getJob(source)
    return job and job.grade
end

function ps.getJobGradeLevel(source)
    local job = ps.getJob(source)
    return job and job.grade and job.grade.level or 0
end

function ps.getJobGradeName(source)
    local job = ps.getJob(source)
    return job and job.grade and job.grade.name
end

function ps.getJobGradePay(source)
    local job = ps.getJob(source)
    return job and job.grade and job.grade.payment or 0
end

function ps.isBoss(source)
    local job = ps.getJob(source)
    return job and job.isboss or false
end

function ps.getAllPlayers()
    local players = {}

    for _, player in pairs(exports.ox_core:GetPlayers() or {}) do
        table.insert(players, player.source)
    end

    return players
end

function ps.getEntityCoords(source)
    local player = ps.getPlayer(source)
    return player and player.getCoords() or GetEntityCoords(GetPlayerPed(source))
end

function ps.getDistance(source, location)
    local pcoords = ps.getEntityCoords(source)
    local loc = vector3(location.x, location.y, location.z)
    return #(pcoords - loc)
end

function ps.checkDistance(source, location, distance)
    if not distance then distance = 2.5 end
    return ps.getDistance(source, location) <= distance
end

function ps.getNearbyPlayers(source, distance)
    if not distance then distance = 10.0 end

    local players = {}
    for _, playerId in pairs(ps.getAllPlayers()) do
        local dist = #(GetEntityCoords(GetPlayerPed(playerId)) - GetEntityCoords(GetPlayerPed(source)))
        if dist < distance then
            table.insert(players, {
                value = ps.getIdentifier(playerId),
                label = ps.getPlayerName(playerId),
                source = playerId,
                distance = dist,
            })
        end
    end

    return players
end

function ps.getJobCount(jobName)
    local players = oxExport('GetGroupActivePlayers', jobName)
    if players then return #players end
    return GlobalState[('%s:activeCount'):format(jobName)] or 0
end

function ps.getJobTypeCount(jobType)
    local count = 0
    local groups = oxExport('GetGroupsByType', jobType) or {}

    for i = 1, #groups do
        count = count + ps.getJobCount(groups[i])
    end

    return count
end

function ps.createUseable(item, func)
    if not item or not func or GetResourceState('ox_inventory') ~= 'started' then return end
    exports.ox_inventory:RegisterHook('usingItem', function(payload)
        if payload.item and payload.item.name == item then
            func(payload.source, payload.item)
        end
    end)
end

function ps.setJob(source, jobName, rank)
    local player = ps.getPlayer(source)
    if not player then return false end

    return player.setGroup(jobName, rank or 1)
end

function ps.setJobDuty(source, duty)
    local player = ps.getPlayer(source)
    if not player then return false end

    if duty then
        local job = ps.getJobName(source)
        return player.setActiveGroup(job)
    end

    return player.setActiveGroup()
end

function ps.addMoney(source, type, amount, reason)
    if type and type ~= 'bank' then return false end

    local player = ps.getPlayer(source)
    if not player then return false end

    local account = player.getAccount()
    local result = account and account.addBalance({ amount = amount or 0, message = reason or 'Added by script' })

    return result and result.success or false
end

function ps.removeMoney(source, type, amount, reason)
    if type and type ~= 'bank' then return false end

    local player = ps.getPlayer(source)
    if not player then return false end

    local account = player.getAccount()
    local result = account and account.removeBalance({ amount = amount or 0, message = reason or 'Removed by script' })

    return result and result.success or false
end

function ps.getMoney(source, type)
    if type and type ~= 'bank' then return 0 end

    local player = ps.getPlayer(source)
    local account = player and player.getAccount()

    return account and account.get('balance') or 0
end

function ps.getAllJobs()
    return oxExport('GetGroupsByType', 'job') or {}
end

function ps.getJobTable()
    local jobs = {}
    local jobNames = ps.getAllJobs()

    for i = 1, #jobNames do
        jobs[jobNames[i]] = ps.getSharedJob(jobNames[i])
    end

    return jobs
end

function ps.getSharedJob(jobName)
    if not getGroup(jobName) and not getGroupState(jobName) then return nil end
    return formatGroup(jobName, 0)
end

function ps.getSharedJobData(jobName, data)
    local job = ps.getSharedJob(jobName)
    return job and job[data]
end

function ps.getSharedJobGrade(jobName, grade)
    local group = getGroup(jobName) or getGroupState(jobName)
    if not group or not group.grades then return nil end

    return group.grades[grade] or group.grades[tostring(grade)]
end

function ps.getSharedJobGradeData(jobName, grade, data)
    local gradeData = ps.getSharedJobGrade(jobName, grade)
    return type(gradeData) == 'table' and gradeData[data] or nil
end

function ps.getGang(source)
    local player = getPlayerByAny(source)
    return getPrimaryGroup(player, 'gang')
end

function ps.getGangName(source)
    local gang = ps.getGang(source)
    return gang and gang.name or 'none'
end

function ps.getGangData(source, data)
    local gang = ps.getGang(source)
    return gang and gang[data]
end

function ps.getGangGrade(source)
    local gang = ps.getGang(source)
    return gang and gang.grade
end

function ps.getGangGradeLevel(source)
    local gang = ps.getGang(source)
    return gang and gang.grade and gang.grade.level or 0
end

function ps.getGangGradeName(source)
    local gang = ps.getGang(source)
    return gang and gang.grade and gang.grade.name
end

function ps.isLeader(source)
    local gang = ps.getGang(source)
    return gang and gang.isboss or false
end

function ps.getAllGangs()
    return oxExport('GetGroupsByType', 'gang') or {}
end

function ps.vehicleOwner(licensePlate)
    local vehicle = MySQL.single.await('SELECT owner FROM vehicles WHERE plate = ?', {licensePlate})
    return vehicle and vehicle.owner or false
end

function ps.jobExists(jobName)
    return ps.getSharedJob(jobName) ~= nil
end

function ps.hasPermission(source, permission)
    local player = ps.getPlayer(source)
    return player and player.hasPermission(permission) or IsPlayerAceAllowed(source, permission)
end

function ps.isOnline(identifier)
    return ps.getPlayerByIdentifier(identifier) ~= nil
end

function ps.getSharedVehicle(model)
    return oxExport('GetVehicleData', model)
end

function ps.getSharedVehicleData(model, dataType)
    local vehicleData = ps.getSharedVehicle(model)
    return vehicleData and vehicleData[dataType] or nil
end

function ps.getSharedWeapons()
    return {}
end

function ps.getSharedWeaponData()
    return nil
end

function ps.getSharedGang(gang)
    if not getGroup(gang) and not getGroupState(gang) then return nil end
    return formatGroup(gang, 0)
end

function ps.getSharedGangData(gang, data)
    local gangData = ps.getSharedGang(gang)
    return gangData and gangData[data] or nil
end

function ps.getSharedGangRankData(gang, rank, data)
    local gradeData = ps.getSharedJobGrade(gang, rank)
    return type(gradeData) == 'table' and gradeData[data] or nil
end

function ps.getSharedItems()
    if GetResourceState('ox_inventory') ~= 'started' then return {} end
    return exports.ox_inventory:Items()
end

function ps.getItemLabel(item)
    local itemData = ps.getSharedItems()[item]
    return itemData and itemData.label or item
end

function ps.getItemWeight(item)
    local itemData = ps.getSharedItems()[item]
    return itemData and itemData.weight or 0
end

RegisterNetEvent('ps_lib:server:toggleDuty', function(bool)
    local src = source
    ps.setJobDuty(src, bool)
end)

exports('getPlayer', ps.getPlayer)
exports('getPlayerByIdentifier', ps.getPlayerByIdentifier)
exports('getPlayerByCid', ps.getPlayerByCid)
exports('getOfflinePlayer', ps.getOfflinePlayer)
exports('getLicense', ps.getLicense)
exports('getIdentifier', ps.getIdentifier)
exports('getCid', ps.getCid)
exports('getSource', ps.getSource)
exports('getPlayerName', ps.getPlayerName)
exports('getName', ps.getName)
exports('getPlayerNameByIdentifier', ps.getPlayerNameByIdentifier)
exports('getPlayerNameByCid', ps.getPlayerNameByCid)
exports('getPlayerData', ps.getPlayerData)
exports('getMetadata', ps.getMetadata)
exports('getCharInfo', ps.getCharInfo)
exports('getJob', ps.getJob)
exports('getJobName', ps.getJobName)
exports('getJobType', ps.getJobType)
exports('getJobDuty', ps.getJobDuty)
exports('getJobData', ps.getJobData)
exports('getJobGrade', ps.getJobGrade)
exports('getJobGradeLevel', ps.getJobGradeLevel)
exports('getJobGradeName', ps.getJobGradeName)
exports('getJobGradePay', ps.getJobGradePay)
exports('isBoss', ps.isBoss)
exports('getAllPlayers', ps.getAllPlayers)
exports('getEntityCoords', ps.getEntityCoords)
exports('getDistance', ps.getDistance)
exports('checkDistance', ps.checkDistance)
exports('getNearbyPlayers', ps.getNearbyPlayers)
exports('getJobCount', ps.getJobCount)
exports('getJobTypeCount', ps.getJobTypeCount)
exports('createUseable', ps.createUseable)
exports('setJob', ps.setJob)
exports('setJobDuty', ps.setJobDuty)
exports('addMoney', ps.addMoney)
exports('removeMoney', ps.removeMoney)
exports('getMoney', ps.getMoney)
exports('getAllJobs', ps.getAllJobs)
exports('getJobTable', ps.getJobTable)
exports('getSharedJob', ps.getSharedJob)
exports('getSharedJobData', ps.getSharedJobData)
exports('getSharedJobGrade', ps.getSharedJobGrade)
exports('getSharedJobGradeData', ps.getSharedJobGradeData)
exports('getGang', ps.getGang)
exports('getGangName', ps.getGangName)
exports('getGangData', ps.getGangData)
exports('getGangGrade', ps.getGangGrade)
exports('getGangGradeLevel', ps.getGangGradeLevel)
exports('getGangGradeName', ps.getGangGradeName)
exports('isLeader', ps.isLeader)
exports('getAllGangs', ps.getAllGangs)
exports('vehicleOwner', ps.vehicleOwner)
exports('jobExists', ps.jobExists)
exports('hasPermission', ps.hasPermission)
exports('isOnline', ps.isOnline)
exports('getSharedVehicle', ps.getSharedVehicle)
exports('getSharedVehicleData', ps.getSharedVehicleData)
exports('getSharedWeapons', ps.getSharedWeapons)
exports('getSharedWeaponData', ps.getSharedWeaponData)
exports('getSharedGang', ps.getSharedGang)
exports('getSharedGangData', ps.getSharedGangData)
exports('getSharedGangRankData', ps.getSharedGangRankData)
