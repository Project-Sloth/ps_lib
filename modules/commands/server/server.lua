
local function canAccess(source, terms)
    if terms.admin then
        if not IsPlayerAceAllowed(source, 'command') then
            return false
        end
    end
    if terms.job then
        if type(terms.job) == 'string' then
            if ps.getJobName(source) ~= terms.job then
                return false
            end
        elseif type(terms.job) == 'table' then
            local jobName = ps.getJobName(source)
            if not ps.tableContains(terms.job, jobName) then
                return false
            end
        end
    end
    if terms.jobRank then
        if terms.jobRank > ps.getJobGradeLevel(source) then
            return false
        end
    end
    if terms.gangRank then
        if terms.gangRank > ps.getGangGradeLevel(source) then
            return false
        end
    end
    if terms.gang then
        if type(terms.gang) == 'string' then
            if ps.getGangName(source) ~= terms.gang then
                return false
            end
        elseif type(terms.gang) == 'table' then
            local gangName = ps.getGangName(source)
            if not ps.tableContains(terms.gang, gangName) then
                return false
            end
        end
    end
    if terms.citizenid then
        if type(terms.citizenid) == 'string' then
            if ps.getIdentifier(source) ~= terms.citizenid then
                return false
            end
        elseif type(terms.citizenid) == 'table' then
            local citizenId = ps.getIdentifier(source)
            if not ps.tableContains(terms.citizenid, citizenId) then
                return false
            end
        end
    end
    if terms.jobType then
        if type(terms.jobType) == 'string' then
            if ps.getJobType(source) ~= terms.jobType then
                return false
            end
        elseif type(terms.jobType) == 'table' then
            local jobType = ps.getJobType(source)
            if not ps.tableContains(terms.jobType, jobType) then
                return false
            end
        end
    end
    return true
end

function ps.registerCommand(name, terms, func)
    if not name then 
        ps.debug('ps.registerCommand: name is required')
        return
    end

    RegisterCommand(name, function(source, args, rawCommand)
        if not canAccess(source, terms) then return end
        func(source, args, rawCommand)
    end, false)

    local suggest = {
        name = '/'..name,
        help = terms.help or '',
        params = terms.description or {}
    }
   TriggerClientEvent('chat:addSuggestions', -1,suggest)
end



function generateCacheKey(length)
    local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+|*-=[]{};':,.<>?/"
    local result = ""

    for i = 1, length do
        local rand = math.random(#charset)
        result = result .. charset:sub(rand, rand)
    end

    return result
end

math.randomseed(os.time())
local key = generateCacheKey(16)


ps.registerCommand('ps-print',{
    admin = true,
    help = 'Turn On Types Of Prints',
    description = {
        {
            name = 'script',
            help = 'Script Name'
        },
        {
            name = 'type',
            help = 'Type of print to turn on'
        }
    }
}, function(source, args, rawCommand)
    local resource = args[1]
    local type = args[2]
    TriggerClientEvent('ps_lib:client:print', source, key, resource, type)
    TriggerEvent('ps_lib:print', resource, type)
end)

ps.registerCallback('ps_lib:print', function(source, keys)
    local src = source
    local keyCheck = keys == key
    key = generateCacheKey(16)
    if IsPlayerAceAllowed(src, 'command') then
        if keyCheck then
            return true
        else
            return false
        end
    end
    return false
end)