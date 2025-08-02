
--- @param source number
--- @return table
--- @description Returns the player object for the given source.
--- @usage local player = ps.getPlayer(source)
function ps.getPlayer(source)
    return qbx:GetPlayer(source)
end

--- @param identifier string
--- @return table
--- @description Returns the player object for the given identifier.
--- @usage local player = ps.getPlayerByIdentifier(identifier)
function ps.getPlayerByIdentifier(identifier)
    return qbx:GetPlayerByCitizenId(identifier) or qbx:GetOfflinePlayer(identifier)
end
ps.getPlayerByCid = ps.getPlayerByIdentifier
--- comment
--- @param identifier string
--- @return table
--- @description Returns the offline player object for the given identifier.
function ps.getOfflinePlayer(identifier)
    return qbx:GetOfflinePlayer(identifier)
end

--- @param source any
--- @return string|nil
--- @description Returns the GTA license identifier for the given source.
function ps.getLicense(source)
    if GetConvarInt('sv_fxdkMode', 0) == 1 then return 'license:fxdk' end
    return GetPlayerIdentifierByType(source, 'license')
end

--- @param source number
--- @return string
--- @description Returns the identifier (citizenid) for the given source.
--- @usage local identifier = ps.getIdentifier(source)
function ps.getIdentifier(source)
    local player = ps.getPlayer(tonumber(source))
    return player.PlayerData.citizenid
end
ps.getCid = ps.getIdentifier


--- @param identifier string
--- @return number
--- @description Returns the source for the given identifier (citizenid).
--- @usage local source = ps.getSource(identifier)
--- @note This function assumes that the identifier is a valid citizenid.
function ps.getSource(identifier)
    local src = ps.getPlayerByIdentifier(identifier).PlayerData.source
    return src
end

--- comment
--- @param source any
--- @return unknown
function ps.getPlayerName(source)
    local player = ps.getPlayer(source)
    return player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
end
ps.getName = ps.getPlayerName -- Alias for compatibility
--- comment
--- @param identifier any
--- @return string
function ps.getPlayerNameByIdentifier(identifier)
    local player = ps.getPlayerByIdentifier(identifier) or ps.getOfflinePlayer(identifier)
    if not player then return 'Unknown Person' end
    return player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
end
ps.getPlayerNameByCid = ps.getPlayerNameByIdentifier -- Alias for compatibility

--- @param source number
--- @return table
--- @description Returns the player data for the given source.
--- @usage local playerData = ps.getPlayerData(source)
--- @note This function returns the PlayerData table which contains job, gang, metadata, and charinfo.
function ps.getPlayerData(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData
end

--- comment
--- @param source any
--- @param meta string
--- @return any
--- @description Returns the metadata value for the given source and metadata key.
function ps.getMetadata(source, meta)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.metadata[meta]
end

--- param source any
--- @param info string
--- @return any
--- @description Returns the character information for the given source and info key.
function ps.getCharInfo(source, info)
    local player = ps.getPlayer(source)
    return player.PlayerData.charinfo[info]
end

--- @param source number
--- @return table
--- @description Returns the job data for the given source.
--- @usage local jobData = ps.getJob(source)
function ps.getJob(source)
    local player = ps.getPlayer(source)
    return player.PlayerData.job
end

--- @param source number
--- @return string
--- @description Returns the job name for the given source.
--- @usage local jobName = ps.getJobName(source)
function ps.getJobName(source)
    local player = ps.getPlayer(source)
    return player.PlayerData.job.name
end


--- @param source number
--- @return string
--- @description Returns the job type for the given source.
function ps.getJobType(source)
    local player = ps.getPlayer(source)
    return player.PlayerData.job.type
end

--- @param source number
--- @return boolean
--- @description Returns whether the player is on duty for the given source.
function ps.getJobDuty(source)
    local player = ps.getPlayer(source)
    return player.PlayerData.job.onduty
end

--- @param source number
--- @return any
--- @description Returns the job data for the given source and data key.
--- @usage local jobData = ps.getJobData(source, 'dataKey')
function ps.getJobData(source, data)
    local player = ps.getPlayer(source)
    return player.PlayerData.job[data]
end

--- @param source number
--- @return table
--- @description Returns the job grade table for the given source.
function ps.getJobGrade(source)
    local player = ps.getPlayer(source)
    return player.PlayerData.job.grade
end

--- comment
--- @param source number
--- @return number
--- @description Returns the job grade level for the given source.
function ps.getJobGradeLevel(source)
    local player = ps.getPlayer(source)
    return player.PlayerData.job.grade.level
end

--- comment
--- @param source number
--- @return string
--- @description Returns the job grade name for the given source.
function ps.getJobGradeName(source)
    local player = ps.getPlayer(source)
    return player.PlayerData.job.grade.name
end

--- comment
--- @param source number
--- @return number
--- @description Returns the job grade payment for the given source.
function ps.getJobGradePay(source)
    local player = ps.getPlayer(source)
    return player.PlayerData.job.grade.payment
end

--- comment
--- @param source number
--- @return boolean
--- @description Returns whether the player is a boss for the given source.
function ps.isBoss(source)
    local player = ps.getPlayer(source)
    return player.PlayerData.job.isboss
end

--- @return table
--- @description Returns a table of all players in the server.
--- @usage local allPlayers = ps.getAllPlayers()
function ps.getAllPlayers()
    return qbx:GetQBPlayers()
end

--- @param source any
--- @return vector3
function ps.getEntityCoords(source)
    return GetEntityCoords(GetPlayerPed(source))
end


--- comment
--- @param source number
--- @param location vector3
--- @return integer
--- @description Returns the distance between the player and a given location.
--- @usage local distance = ps.getDistance(source, vector3(0, 0, 0))
function ps.getDistance(source, location)
    local pcoords = GetEntityCoords(GetPlayerPed(source))
    local loc = vector3(location.x, location.y, location.z)
    return #(pcoords - loc)
end


---@param source number
---@param location vector3
---@param distance number
---@return boolean
---@description Checks if the player is within a certain distance from a given location.
--- @usage local isNearby = ps.checkDistance(source, vector3(0, 0, 0), 5.0)
function ps.checkDistance(source, location, distance)
    if not distance then distance = 2.5 end
    local pcoords = GetEntityCoords(GetPlayerPed(source))
    local loc = vector3(location.x, location.y, location.z)
    return #(pcoords - loc) <= distance
end


--- @param source number
--- @param distance number
--- @return table
--- @description Returns a table of nearby players within a certain distance.
--- @usage local nearbyPlayers = ps.getNearbyPlayers(source, 10.0)
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

--- comment
--- @param jobName string
--- @return integer
--- @description Returns the count of players with a specific job who are on duty.
--- @usage local jobCount = ps.getJobCount('police')
function ps.getJobCount(jobName)
    local count = 0
    for _, player in pairs(ps.getAllPlayers()) do
        if player.job and player.job.name == jobName and ps.getJobDuty(player.source) then
            count = count + 1
        end
    end
    return count
end

--- comment
--- @param jobName string
--- @return integer
--- @description Returns the count of players with a specific job type who are on duty.
--- @usage local jobTypeCount = ps.getJobTypeCount('leo')
function ps.getJobTypeCount(jobName)
    local count = 0
    for _, playerData in pairs(ps.getAllPlayers()) do
        if playerData.job and playerData.job.type == jobName and ps.getJobDuty(playerData.source) then
            count = count + 1
        end
    end
    return count
end

--- @param item string
--- @param func function
--- @description Creates a usable item that can be used by players.
--- @usage ps.createUseable('water_bottle', function(source, item)
---             -- Your code here
---         end)
function ps.createUseable(item, func)
    if not item or not func then return end
    qbx:CreateUseableItem(item, func)
end

--- @param source number
--- @param jobName string
--- @param jobGrade integer
--- @return boolean
function ps.setJob(source, jobName, jobGrade)
    if not source or not jobName or not jobGrade then
        return false
    end
    local player = ps.getPlayer(source)
    local job = qbx:GetJobs()[jobName]
    player.PlayerData.job = {
        name = jobName,
        label = job.label,
        isboss = job.grades[jobGrade].isboss or false,
        onduty = job.defaultDuty or false,
        payment = job.grades[jobGrade].payment or 0,
        type = job.type,
        grade = {
            name = job.grades[jobGrade].name,
            level = jobGrade
        }
    }
    TriggerEvent('QBCore:Server:OnJobUpdate', player.PlayerData.source, player.PlayerData.job)
    TriggerClientEvent('QBCore:Client:OnJobUpdate', player.PlayerData.source, player.PlayerData.job)
    exports.qbx_core:SetPlayerData(player.PlayerData.citizenid, 'job', player.PlayerData.job)
end

--- @param source number
--- @param duty boolean
--- @description Sets the job duty status for a player.
--- @usage ps.setJobDuty(source, true)
function ps.setJobDuty(source, duty)
    local identifier = ps.getIdentifier(source)
    exports.qbx_core:SetJobDuty(identifier, duty)
end


--- @param source number
--- @param type string
--- @param amount number
--- @param reason string
--- @return boolean
function ps.addMoney(source, type, amount, reason)
    if not type then type = 'cash' end
    if not amount then amount = 0 end
    if not reason then reason = 'No reason provided' end
    return qbx:AddMoney(source, type, amount, reason)
end

--- @param source number
--- @param type string
--- @param amount number
--- @param reason string
--- @return boolean
function ps.removeMoney(source, type, amount, reason)
    if not type then type = 'cash' end
    if not amount then amount = 0 end
    if not reason then reason = 'No reason provided' end
    return qbx:RemoveMoney(source, type, amount, reason)
end

--- @param source number
--- @param type string
--- @return number
function ps.getMoney(source, type)
    return qbx:GetMoney(source, type or 'cash')
end

--- @return table
--- @description Returns a table of all jobs available in the server.
--- @example {'police', 'ambulance', 'mechanic'}
function ps.getAllJobs()
    local jobsArray = {}
    for k, v in pairs(qbx:GetJobs()) do
        table.insert(jobsArray, k)
    end
    return jobsArray
end


function ps.getJobTable()
    return qbx:GetJobs()
end

--- @param jobName string
--- @return table
--- @description Returns the job data for a specific job name.
--- @usage local jobData = ps.getSharedJob(jobName)
function ps.getSharedJob(jobName)
    local jobList = qbx:GetJobs()
    return jobList[jobName]
end

function ps.getSharedJobData(jobName, data)
    local jobList = qbx:GetJobs()
    if jobList[jobName] and jobList[jobName][data] then
        return jobList[jobName][data]
    else
        return nil
    end
end

--- comment
--- @param jobName string
--- @param grade integer
--- @return table
function ps.getSharedJobGrade(jobName, grade)
   local jobList = qbx:GetJobs()
    if jobList[jobName] and jobList[jobName].grades[grade] then
        return jobList[jobName].grades[grade]
    else
        return nil
    end
end

--- comment
---@param source number
---@return table
---@description Returns the gang data for the given source.
function ps.getGang(source)
    local player = ps.getPlayer(source)
    return player.PlayerData.gang
end

--- @param source number
--- @return string
--- @description Returns the gang name for the given source.
--- @usage local gangName = ps.getGangName(source)
function ps.getGangName(source)
    local player = ps.getPlayer(source)
    return player.PlayerData.gang.name
end

--- @param source number
--- @return string
--- @description Returns the gang type for the given source.
--- @usage local gangType = ps.getGangType(source)
function ps.getGangData(source, data)
    local player = ps.getPlayer(source)
    return player.PlayerData.gang[data]
end

--- @param source number
--- @return number
--- @description Returns the gang grade level for the given source.
function ps.getGangGrade(source)
    local player = ps.getPlayer(source)
    return player.PlayerData.gang.grade
end

--- comment
--- @param source number
--- @return number
--- @description Returns the gang grade level for the given source.
function ps.getGangGradeLevel(source)
    local player = ps.getPlayer(source)
    return player.PlayerData.gang.grade.level
end

--- @param source number
--- @return string
--- @description Returns the gang grade name for the given source.
function ps.getGangGradeName(source)
    local player = ps.getPlayer(source)
    return player.PlayerData.gang.grade.name
end

--- @param source number
--- @return boolean
--- @description Returns whether the player is a gang leader for the given source.
--- @usage local isLeader = ps.isLeader(source)
function ps.isLeader(source)
    local player = ps.getPlayer(source)
    return player.PlayerData.gang.isboss
end

--- @return table
--- @description Returns a table of all gangs available in the server.
--- @example {'ballas', 'vagos', 'lost'}
--- @usage local allGangs = ps.getAllGangs()
function ps.getAllGangs()
     local gangsArray = {}
    for k, v in pairs(qbx:GetGangs()) do
        table.insert(gangsArray, k)
    end
    return gangsArray
end

--- @param licensePlate string
--- @return string|boolean
--- @description Returns the owner of a vehicle by its license plate.
--- @usage local owner = ps.vehicleOwner('ABC123')
function ps.vehicleOwner(licensePlate)
    local vehicle = MySQL.query.await('SELECT * FROM player_vehicles WHERE plate = ?', {licensePlate})
    if not vehicle or #vehicle == 0 then
        return false
    end
    return vehicle[1].citizenid
end


--- @param jobName string
--- @return boolean
--- @description Checks if a job exists in the server.
--- @usage local exists = ps.jobExists('police')
function ps.jobExists(jobName)
    return exports.qbx_core:GetJobs()[jobName] ~= nil
end


--- comment
--- @param source any
--- @param permission any
--- @return boolean
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


---- start fix of bridge from qb
---
----- Shared Functions -----
function ps.getSharedVehicle(model)
    local vehicleData = exports.qbx_core:GetVehiclesByName()
    if not vehicleData then return nil end
    return vehicleData[model]
end

function ps.getSharedVehicleData(model, dataType)
    local vehicleData = ps.getSharedVehicle(model)
    if not vehicleData then return nil end
    return vehicleData[dataType] or nil
end

function ps.getSharedWeapons(model)
    if type(model) == 'string' then model = GetHashKey(model) end
    local weaponData = exports.qbx_core:GetWeapons()
    if not weaponData then return nil end
    return weaponData[model]
end

function ps.getSharedWeaponData(model, dataType)
    local weaponData = ps.getSharedWeapons(model)
    if not weaponData then return nil end
    return weaponData[dataType] or nil
end



function ps.getSharedJobGradeData(job, rank, data)
    local jobData = ps.getSharedJob(job)
    if not jobData then return nil end
    local gradeData = jobData.grades[tostring(rank)]
    if not gradeData then return nil end
    return gradeData[data] or nil
end

function ps.getSharedGang(gang)
    local gangData = exports.qbx_core:GetGangs()
    if not gangData then return nil end
    return gangData[gang]
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

RegisterNetEvent('ps_lib:server:toggleDuty', function()
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
