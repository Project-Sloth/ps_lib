--- Player Getters
function ps.getPlayer(source)
    return QBCore.Functions.GetPlayer(source)
end

function ps.getPlayerByIdentifier(identifier)
    return QBCore.Functions.GetPlayerByCitizenId(identifier) or QBCore.Functions.GetOfflinePlayerByCitizenId(identifier)
end

function ps.getOfflinePlayer(identifier)
    return QBCore.Functions.GetOfflinePlayerByCitizenId(identifier)
end

function ps.getIdentifier(source)
    local player = ps.getPlayer(source)
    return player.PlayerData.citizenid
end

function ps.getSource(identifier)
    local player = ps.getPlayerByIdentifier(identifier)
    if not player then return nil end
    return player.PlayerData.source
end

function ps.getPlayerName(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
end

function ps.getPlayerNameByIdentifier(identifier)
    local player = ps.getPlayerByIdentifier(identifier) or ps.getOfflinePlayer(identifier)
    if not player then return 'Unknown Person' end
    return player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
end

function ps.getPlayerData(source)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData
end

function ps.getMetadata(source, meta)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.metadata[meta]
end

function ps.getCharInfo(source, info)
    local player = ps.getPlayer(source) or ps.getPlayerByIdentifier(source) or ps.getOfflinePlayer(source)
    return player.PlayerData.charinfo[info]
end

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


function ps.vehicleOwner(licensePlate)
    local vehicle = MySQL.query.await('SELECT * FROM player_vehicles WHERE plate = ?', {licensePlate})
    if not vehicle or #vehicle == 0 then
        return false
    end
    return vehicle[1].citizenid
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

function ps.getJobTable()
    return QBCore.Shared.Jobs
end

function ps.jobExists(jobName)
    return QBCore.Shared.Jobs[jobName] ~= nil
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

function ps.getSharedJobRankData(job, rank, data)
    local jobData = ps.getSharedJob(job)
    if not jobData then return nil end
    local gradeData = jobData.grades[tostring(rank)]
    if not gradeData then return nil end
    return gradeData[data] or nil
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

function ps.getAllJobs()
    local jobsArray = {}
    for k, v in pairs(QBCore.Shared.Jobs) do
        table.insert(jobsArray, k)
    end
    return jobsArray
end

function ps.getAllGangs()
     local gangsArray = {}
    for k, v in pairs(QBCore.Shared.Gangs) do
        table.insert(gangsArray, k)
    end
    return gangsArray
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
