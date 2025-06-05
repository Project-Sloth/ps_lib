ps.registerCallback('ps_lib:esx:getVehicleLabel', function(model)
   MySQL.query.await('SELECT name FROM vehicles WHERE model = ?', {model}, function(result)
      if result and result[1] then
         return result[1].name
      else
         return GetDisplayNameFromVehicleModel(model)
      end
   end)
end)

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

function ps.getMetadata(source, meta)
    local player = ps.getPlayer(source)
    return player.PlayerData.metadata[meta]
end

function ps.getCharInfo(source, info)
    local player = ps.getPlayer(source)
    return player.PlayerData.charinfo[info]
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
    return player.job.type or player.job.name
end

-- no support for duty ????
function ps.getJobDuty(source)
    local player = ps.getPlayer(source)
    return player.job.onduty
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
    return player.job.grade
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
    local player = ps.getPlayer(source)
    return player.job.name == 'boss'
end

function ps.getAllPlayers()
    return ESX.GetPlayers(false, false)
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
    ESX.RegisterUseableItem(item, func)
end

function ps.setJob(source, jobName, rank)
    local player = ps.getPlayer(source)
    if not player then return end
    local job = QBCore.Shared.Jobs[jobName]
    if not job then return end
    player.SetJob(job.name, rank or 0, true)
    return true
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
        if player.removeAccountMoney('bank', amount, reason or 'Removed by script') then
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
    if type == 'cash' then
        return player.getMoney()
    elseif type == 'bank' then
        return player.getAccount('bank').money
    end
end
