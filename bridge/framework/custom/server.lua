
function ps.getPlayer(source)
    return
end

function ps.getPlayerByIdentifier(identifier)
    return
end

function ps.getOfflinePlayer(identifier)
    return
end

function ps.getIdentifier(source)
    return
end


function ps.getPlayerName(source)
    return
end

function ps.getPlayerNameByIdentifier(identifier)
    return
end


function ps.getPlayerData(source)
    return
end


function ps.getMetadata(source, meta)
    return
end

function ps.getCharInfo(source, info)
    return
end


function ps.getJob(source)
    return
end


function ps.getJobName(source)
    return
end


function ps.getJobType(source)
    return
end


function ps.getJobDuty(source)
    return
end

function ps.getJobData(source, data)
    return
end


function ps.getJobGrade(source)
    return
end


function ps.getJobGradeName(source)
    return
end


function ps.getJobGradePay(source)
    return
end


function ps.isBoss(source)
    return
end


function ps.getAllPlayers()
    return
end


function ps.getDistance(source, location)
    local pcoords = GetEntityCoords(GetPlayerPed(source))
    local loc = vector3(location.x, location.y, location.z)
    return #(pcoords - loc)
end

function ps.getNearbyPlayers(source, distance)
    return
end


function ps.getJobCount(jobName)
    return
end


function ps.getJobTypeCount(jobName)
    return
end

function ps.createUseable(item, func)
    return
end
