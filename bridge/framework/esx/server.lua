ps.Shared = {}
local esxJOBCompat = {
    ['police'] = 'leo',
    ['unemployed'] = 'loser',
    ['ambulance'] = 'ems',
    ['mechanic'] = 'mechanic',
    ['cardealer'] = 'cardealer',

}

local jobs, vehicles = {}, {}
local function handleJobGrades(jobName)
    local result = MySQL.query.await('SELECT * FROM job_grades WHERE job_name = ?', {jobName})
    local grades = {}
    for k, v in pairs(result) do
        grades[tostring(v.grade)] = {
            name = v.label,
            payment = v.salary,
        }
        if v.label == 'boss' then
            jobs[jobName].isboss = v.grade
        end
    end
    return grades
end

local function loadJobsCompat()
    local result = MySQL.query.await('SELECT * FROM jobs',{})
    for k, v in pairs(result) do
        jobs[v.name] = {
            label = v.label,
            defaultDuty = false,
            type = esxJOBCompat[v.name] or 'none',
            offDutyPay = 0,
            grades = handleJobGrades(v.name),
        }
    end
end

local function loadVehiclesCompat()
    local result = MySQL.query.await('SELECT * FROM vehicles')
    for k, v in pairs(result) do
        vehicles[v.model] = {
            name = v.name,
            price = v.price,
            category = v.category,
        }
    end
end
loadJobsCompat()
loadVehiclesCompat()
ps.Shared.Vehicles = vehicles
ps.Shared.Jobs = jobs

ps.registerCallback('ps_lib:esx:getVehicleLabel', function(model)
   MySQL.query.await('SELECT name FROM vehicles WHERE model = ?', {model}, function(result)
      if result and result[1] then
         return result[1].name
      else
         return GetDisplayNameFromVehicleModel(model)
      end
   end)
end)

function ps.getJobTable()
    return jobs
end
---
function ps.getPlayer(source)
    return ESX.GetPlayerFromId(source)
end

function ps.getPlayerByIdentifier(identifier)
    return ESX.GetPlayerFromIdentifier(identifier)
end

function ps.getOfflinePlayer(identifier)
    return ESX.GetPlayerFromIdentifier(identifier)
end

function ps.getIdentifier(source)
    local Player = ps.getPlayer(source)
    if not Player then return nil end
    return Player.getIdentifier()
end

function ps.getSource(identifier)
    local player = ps.getPlayerByIdentifier(identifier)
    if not player then return nil end
    return player.source
end

function ps.getPlayerName(source)
    local player = ps.getPlayer(source)
    return player.name
end

function ps.getPlayerNameByIdentifier(identifier)
    local player = ps.getPlayerByIdentifier(identifier) or ps.getOfflinePlayer(identifier)
    if not player then return 'Unknown Person' end
    return player.name
end

function ps.getPlayerData(source)
    local player = ps.getPlayer(source)
    return player.PlayerData
end

local function getStatus(source, type)
    local player = ps.getPlayer(source)
    for k, v in pairs (player.variables.status) do 
        if v.name == type then 
            return math.floor(v.percent)
        end
    end
    return 0
end

function ps.getMetadata(source, meta)
    local player = ps.getPlayer(source)
    local metas = {
        hunger = getStatus(source, 'hunger'),
        thirst = getStatus(source, 'thirst'),
        stress = getStatus(source, 'stress'),
        isdead = player.isDead,
    }
    return metas[meta]
end

function ps.getCharInfo(source, info)
    local player = ps.getPlayer(source)
    local charinfo = {
        firstname = player.firstName,
        lastname = player.lastName,
        birthdate = player.dateofbirth,
        gender = player.sex
    }
    return charinfo[info] or nil
end

function ps.getJob(source)
    local player = ps.getPlayer(source)
    return player.job
end

function ps.getJobName(source)
    local player = ps.getPlayer(source)
    return player.job.name
end

function ps.getJobType(source)
    local player = ps.getPlayer(source)
    return esxJOBCompat[player.job.name] or 'none'
end

function ps.getJobDuty(source)
    local player = ps.getPlayer(source)
    return player.job.onDuty
end


function ps.getJobData(source, data)
    local player = ps.getPlayer(source)
    return player.job[data]
end

function ps.getJobGrade(source)
    local player = ps.getPlayer(source)
    return player.job.grade
end

function ps.getJobGradeLevel(source)
    local player = ps.getPlayer(source)
    return player.job.grade_level
end

function ps.getJobGradeName(source)
    local player = ps.getPlayer(source)
    return player.job.grade_name
end

function ps.getJobGradePay(source)
    local player = ps.getPlayer(source)
    return player.job.grade_salary
end

function ps.isBoss(source)
    local name = ps.getJobGradeName(source)
    return name == 'boss'
end

function ps.getAllPlayers()
    return ESX.GetPlayers()
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
        local p = ps.getPlayer(player)
        if p.job.name == jobName and p.job['onDuty'] then
            count = count + 1
        end
    end
    return count
end

function ps.getJobTypeCount(jobName)
    local count = 0
    for _, player in pairs(ps.getAllPlayers()) do
        local playerData = ps.getPlayerData(player)
        local typeJob = esxJOBCompat[playerData.job.name] or 'none'
        if playerData.job and typeJob == jobName and ps.getJobDuty(player) then
            count = count + 1
        end
    end
    return count
end

function ps.createUseable(item, func)
    if not item or not func then return end
    ESX.RegisterUseableItem(item, func)
end

function ps.setJob(source, jobName, rank)
    local player = ps.getPlayer(source)
    local exist = ESX.DoesJobExist(jobName, rank)
    if not exist then return false end
    player.setJob(jobName, rank)
    return true
end

function ps.setJobDuty(source, duty)
    local player = ps.getPlayer(source)
    if not player then return false end
    player.setJob(player.job.name, player.job.grade, duty)
    return false
end

function ps.addMoney(source,type, amount, reason)
    local player = ps.getPlayer(source)
    if not player then return end
    if type == 'cash' then
        player.addMoney(amount, reason or 'Added by script')
        return true
    elseif type == 'bank' then
        player.addAccountMoney('bank', amount, reason or 'Added by script')
        return true
    end
    return false
end

function ps.removeMoney(source, type,  amount, reason)

    local player = ps.getPlayer(source)
    if not player then return end
    if type == 'cash' then
        if player.removeMoney(amount, reason or 'Removed by script') then
            return true
        else
            return false
        end
    elseif type == 'bank' then
        local balance = player.getAccount('bank').money
        if balance - amount >= 0 then 
            player.removeAccountMoney('bank', amount, reason or 'Removed by script')
            return true
        else
            return false
        end
    end
    return false
end

function ps.getMoney(source, type)
    local player = ps.getPlayer(source)
    if not player then return 0 end
    if not type then type = 'cash' end
    if type == 'cash' then
        return player.getMoney()
    elseif type == 'bank' then
        return player.getAccount('bank').money
    end
end

local function getGradesFormatted(jobName)
    local grades = MySQL.query.await('SELECT * FROM job_grades WHERE job_name = ?', {jobName})
    local formattedGrades = {}
    for i = 1, #grades do
        local grade = grades[i]
        formattedGrades[grade.grade] = {
            name = grade.label,
            level = grade.grade,
            payment = grade.salary,
        }
    end
    return formattedGrades
end

function ps.getAllJobs()
    local jobSend = {}
    for k, v in pairs (jobs) do
        table.insert(jobSend, k)
    end
    return jobSend
end

function ps.getSharedJob(jobName)
    if not jobName then return nil end
    local job = ps.Shared.Jobs[jobName]
    if not job then return nil end
    return job
end

function ps.getSharedJobGrade(jobName, grade)
    if type(grade) == 'number' then
        grade = tostring(grade)
    end
    local job = ps.Shared.Jobs[jobName]
    if not job then return nil end
    
    local job = ps.Shared.Jobs[jobName]
    return job.grades[grade] or nil
end

-- Someone PR This 
function ps.getGang(source)
   -- local player = ps.getPlayer(source)
   -- return player.PlayerData.gang
end

function ps.getGangName(source)
   -- local player = ps.getPlayer(source)
   -- return player.PlayerData.gang.name
end

function ps.getGangData(source, data)
   -- local player = ps.getPlayer(source)
   -- return player.PlayerData.gang[data]
end

function ps.getGangGrade(source)
   -- local player = ps.getPlayer(source)
   -- return player.PlayerData.gang.grade
end

function ps.getGangGradeLevel(source)
   -- local player = ps.getPlayer(source)
   -- return player.PlayerData.gang.grade.level
end

function ps.getGangGradeName(source)
   -- local player = ps.getPlayer(source)
   -- return player.PlayerData.gang.grade.name
end

function ps.isLeader(source)
    --local player = ps.getPlayer(source)
    --return player.PlayerData.gang.isboss
end

function ps.getAllGangs()
    --local gangsArray = {}
    --for k, v in pairs(qbx:GetGangs()) do
    --    table.insert(gangsArray, k)
    --end
    --return gangsArray
end

-- End PR Plz

function ps.vehicleOwner(licensePlate)
    local vehicle = MySQL.query.await('SELECT * FROM owned_vehicles WHERE plate = ?', {licensePlate})
    if not vehicle or #vehicle == 0 then
        return false
    end
    return vehicle[1].owner
end

function ps.jobExists(jobName)
    return ps.Shared.Jobs[jobName] ~= nil
end

function ps.hasPermission(source, permission)
    if IsPlayerAceAllowed(source, permission) then
        return true
    end
end

function ps.getSharedItems()
    return exports.ox_inventory:GetItems()
end

function ps.getItemLabel(item)
    local itemData = ps.getSharedItems()[item]
    if not itemData then return item end
    return itemData.label
end

function ps.getItemWeight(item)
    local itemData = ps.getSharedItems()[item]
    if not itemData then return 0 end
    return itemData.weight or 0
end


RegisterNetEvent('ps_lib:server:toggleDuty', function(bool)
    local src = source
    ps.setJobDuty(src, bool)
end)