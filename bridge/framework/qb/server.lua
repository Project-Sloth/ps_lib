--- Player Getters

--- @param source any
--- @return unknown
--- @description Returns the player object for the given source.
function ps.getPlayer(source)
    return QBCore.Functions.GetPlayer(source)
end

--- @param identifier string
--- @return table|nil
--- @description Returns the player object for the given identifier.
function ps.getPlayerByIdentifier(identifier)
    return QBCore.Functions.GetPlayerByCitizenId(identifier) or QBCore.Functions.GetOfflinePlayerByCitizenId(identifier)
end
ps.getPlayerByCid = ps.getPlayerByIdentifier


--- @param identifier string
--- @return table|nil
--- @description Returns the offline player object for the given identifier.
function ps.getOfflinePlayer(identifier)
    return QBCore.Functions.GetOfflinePlayerByCitizenId(identifier)
end

--- @param source any
--- @return string|nil
--- @description Returns the GTA license identifier for the given source.
function ps.getLicense(source)
    if GetConvarInt('sv_fxdkMode', 0) == 1 then return 'license:fxdk' end
    return GetPlayerIdentifierByType(source, 'license')
end

--- @param source any
--- @return string|nil
--- @description Returns the citizen identifier for the given source.
function ps.getIdentifier(source)
    local player = ps.getPlayer(source)
    return player.PlayerData.citizenid
end
ps.getCid = ps.getIdentifier 


--- @param identifier string
--- @return string|nil
--- @description Returns the citizen identifier for the given identifier.
function ps.getSource(identifier)
    local player = ps.getPlayerByIdentifier(identifier)
    if not player then return nil end
    return player.PlayerData.source
end

--- @param source any
--- @return string
--- @description Returns the full name of the player for the given source.
function ps.getPlayerName(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
end
ps.getName = ps.getPlayerName


--- @param identifier string
--- @return string
--- @description Returns the full name of the player for the given identifier.
function ps.getPlayerNameByIdentifier(identifier)
    local player = ps.getPlayerByIdentifier(identifier) or ps.getOfflinePlayer(identifier)
    if not player then return 'Unknown Person' end
    return player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
end
ps.getPlayerNameByCid = ps.getPlayerNameByIdentifier
--- @param source any
--- @return table
--- @description Returns the PlayerData for the given source.
function ps.getPlayerData(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData
end

--- @param source any
--- @param meta string
--- @return any
--- @description Returns the metadata for the given source and meta key.
--- @example
--- ps.getMetadata(source, 'bloodtype') -- returns the blood type of the player
function ps.getMetadata(source, meta)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.metadata[meta]
end

--- @param source any
--- @param info string
--- @return any
--- @description Returns the character info for the given source and info key.
--- @example
--- ps.getCharInfo(source, 'age') -- returns the age of the character
function ps.getCharInfo(source, info)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.charinfo[info]
end

--- @param source any
--- @return string
--- @description
--- @return The job object for the given source.
--- @example
--- ps.getJob(source) -- returns the job object of the player
function ps.getJob(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.job
end

function ps.getJobName(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.job.name
end

function ps.getJobType(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.job.type
end

function ps.getJobDuty(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.job.onduty
end

function ps.getJobData(source, data)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.job[data]
end

function ps.getJobGrade(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.job.grade
end

function ps.getJobGradeLevel(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.job.grade.level
end

function ps.getJobGradeName(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.job.grade.name
end

function ps.getJobGradePay(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.job.grade.payment
end

function ps.isBoss(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.job.isboss
end

function ps.getAllPlayers()
    return QBCore.Functions.GetPlayers()
end

function ps.getEntityCoords(source)
    return GetEntityCoords(GetPlayerPed(source))
end

function ps.getDistance(source, location)
    local pcoords = GetEntityCoords(GetPlayerPed(source))
    local loc = vector3(location.x, location.y, location.z)
    return #(pcoords - loc)
end

function ps.checkDistance(source, location, distance)
    if not distance then distance = 2.5 end
    local pcoords = GetEntityCoords(GetPlayerPed(source))
    local loc = vector3(location.x, location.y, location.z)
    return #(pcoords - loc) <= distance
end

function ps.getNearbyPlayers(source, distance)
    if not distance then distance = 10.0 end
    local players = {}
    for k, v in pairs(ps.getAllPlayers()) do
        local dist = #(GetEntityCoords(GetPlayerPed(v)) - GetEntityCoords(GetPlayerPed(source)))
        if dist < 5.0 then
            table.insert(players, {
                value = ps.getIdentifier(v),
                label = ps.getPlayerName(v),
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
    QBCore.Functions.CreateUseableItem(item, func)
end

function ps.setJob(source, jobName, rank)
    local player = ps.getPlayer(source)
    if not player then return end
    local job = QBCore.Shared.Jobs[jobName]
    if not job then return end
    player.Functions.SetJob(jobName, rank or 0)
end

function ps.setJobDuty(source, duty)
    local player = ps.getPlayer(source)
    if not player then return end
    player.Functions.SetJobDuty(duty)
end

function ps.addMoney(source,type, amount, reason)
    local player = ps.getPlayer(source)
    if not type then type = 'cash' end
    if not amount then amount = 0 end
    if not reason then reason = 'No reason provided' end
    player.Functions.AddMoney(type, amount, reason or 'Added by script')
    return true
end

function ps.removeMoney(source, type,  amount, reason)
    local player = ps.getPlayer(source)
    if not type then type = 'cash' end
    if not amount then amount = 0 end
    if not reason then reason = 'No reason provided' end
    if player.Functions.RemoveMoney(type, amount, reason or 'Removed by script') then
        return true
    else
        return false
    end
end

function ps.getMoney(source, type)
    local player = ps.getPlayer(source)
    if not type then type = 'cash' end
    return player.PlayerData.money[type] or 0
end

function ps.getAllJobs()
    local jobsArray = {}
    for k, v in pairs(QBCore.Shared.Jobs) do
        table.insert(jobsArray, k)
    end
    return jobsArray
end


function ps.getJobTable()
    return QBCore.Shared.Jobs
end


function ps.getSharedJob(job)
    local jobData = QBCore.Shared.Jobs[job]
    if not jobData then return nil end
    return jobData
end

function ps.getSharedJobData(job, data)
    local jobData = ps.getSharedJob(job)
    if not jobData then return nil end
    return jobData[data] or nil
end

function ps.getSharedJobGrade(jobName, grade)
    local jobData = ps.getSharedJob(jobName)
    if not jobData then return nil end
    local gradeData = jobData.grades[tostring(grade)]
    if not gradeData then return nil end
    return gradeData
end

function ps.getSharedJobGradeData(job, rank, data)
    local jobData = ps.getSharedJob(job)
    if not jobData then return nil end
    local gradeData = jobData.grades[tostring(rank)]
    if not gradeData then return nil end
    return gradeData[data] or nil
end

function ps.getGang(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.gang
end

function ps.getGangName(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.gang.name
end

function ps.getGangData(source, data)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.gang[data]
end

function ps.getGangGrade(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.gang.grade
end

function ps.getGangGradeLevel(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.gang.grade.level
end

function ps.getGangGradeName(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.gang.grade.name
end

function ps.isLeader(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.gang.isboss
end

function ps.getAllGangs()
     local gangsArray = {}
    for k, v in pairs(QBCore.Shared.Gangs) do
        table.insert(gangsArray, k)
    end
    return gangsArray
end

function ps.vehicleOwner(licensePlate)
    local vehicle = MySQL.query.await('SELECT * FROM player_vehicles WHERE plate = ?', {licensePlate})
    if not vehicle or #vehicle == 0 then
        return false
    end
    return vehicle[1].citizenid
end

function ps.jobExists(jobName)
    return QBCore.Shared.Jobs[jobName] ~= nil
end



function ps.hasPermission(source, permission)
    if IsPlayerAceAllowed(source, permission) then
        return true
    end
end

function ps.isOnline(identifier)
    local player = ps.getPlayerByIdentifier(identifier)
    if player then return true end
    return false
end

----- Shared Functions -----
function ps.getSharedVehicle(model)
    local vehicleData = QBCore.Shared.Vehicles[model]
    if not vehicleData then return nil end
    return vehicleData
end

function ps.getSharedVehicleData(model, dataType)
    local vehicleData = ps.getSharedVehicle(model)
    if not vehicleData then return nil end
    return vehicleData[dataType] or nil
end

function ps.getSharedWeapons(model)
    if type(model) == 'string' then model = GetHashKey(model) end
    local weaponData = QBCore.Shared.Weapons[model]
    if not weaponData then return nil end
    return weaponData
end

function ps.getSharedWeaponData(model, dataType)
    local weaponData = ps.getSharedWeapons(model)
    if not weaponData then return nil end
    return weaponData[dataType] or nil
end





function ps.getSharedGang(gang)
    local gangData = QBCore.Shared.Gangs[gang]
    if not gangData then return nil end
    return gangData
end

function ps.getSharedGangData(gang, data)
    local gangData = ps.getSharedGang(gang)
    if not gangData then return nil end
    return gangData[data] or nil
end

function ps.getSharedGangRankData(gang, rank, data)
    local gangData = QBCore.Shared.Gangs[gang]
    if not gangData then return nil end
    local gradeData = gangData.grades[tostring(rank)]
    if not gradeData then return nil end
    return gradeData[data] or nil
end




-- end shared functions
RegisterNetEvent('ps_lib:server:toggleDuty', function(bool)
    local src = source
    local duty = ps.getJobDuty(src)
    if duty then 
        ps.setJobDuty(src, false)
    else
        ps.setJobDuty(src, true)
    end
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
