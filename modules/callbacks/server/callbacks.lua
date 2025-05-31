local callbacks = {}
local pendingCallbacks = {}

function ps.registerCallback(name, cb)
    callbacks[name] = cb
end

function ps.callback(name, source, ...)
    local cb = nil
    local args = {...}

    if type(args[1]) == 'function' then
        cb = args[1]
        table.remove(args, 1)
    end

    pendingCallbacks[name] = {
        callback = cb,
        promise = promise.new()
    }

    TriggerClientEvent('ps_lib:client:triggerClientCallback', source, name, table.unpack(args))

    if cb == nil then
        local result = Citizen.Await(pendingCallbacks[name].promise)
        return result
    end
end

RegisterNetEvent('ps_lib:Server:triggerClientCallback', function(name, ...)
    if not pendingCallbacks[name] then
        ps.error('No pending callback found for: ' .. name)
        return
    end
    if pendingCallbacks[name] then
        pendingCallbacks[name].promise:resolve(...)
        if pendingCallbacks[name].callback then
           pendingCallbacks[name].callback(...)
        end
        pendingCallbacks[name] = nil
    else
        ps.error('No pending callback found for: ' .. name)
    end
end)


RegisterNetEvent('ps_lib:server:triggerCallback', function(name, ...)
    local src = source
    if not callbacks[name] then
        ps.error('Server Callback with name ' .. name .. ' does not exist.')
        TriggerClientEvent('ps_lib:client:noCallback', source, name)
        return
    end

    local result = callbacks[name](src, function(...)
        TriggerClientEvent('ps_lib:client:triggerCallback', src, name, ...)
    end, ...)

    if result ~= nil then
        TriggerClientEvent('ps_lib:client:triggerCallback', src, name, result)
    end
end)

RegisterNetEvent('ps_lib:server:noCallback', function(name)
    ps.error('no Client callback registered for: ' .. name)
    pendingCallbacks[name].promise:resolve(nil)
    pendingCallbacks[name] = nil
end)

ps.registerCallback('getName', function(source)
    local src = source
    local name = ps.getPlayerName(src)
    return name
end)

-- TODO: Add Timeout function so it won't wait forever