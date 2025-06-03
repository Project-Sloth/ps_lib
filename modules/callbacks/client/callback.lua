local callbacks = {}
local pendingCallbacks = {}

function ps.registerCallback(name, cb)
    callbacks[name] = cb
end

function ps.callback(name, ...)
    local cb = nil
    local args = { ... }

    if type(args[1]) == 'function' then
        cb = args[1]
        table.remove(args, 1)
    end
    pendingCallbacks[name] = {
        callback = cb,
        promise = promise.new()
    }

    TriggerServerEvent('ps_lib:server:triggerCallback', name, table.unpack(args))

    if cb == nil then
        local result = Citizen.Await(pendingCallbacks[name].promise)
        return result
    end
end

RegisterNetEvent('ps_lib:client:triggerClientCallback', function(name, ...)
    if not callbacks[name] then
        ps.error('Server Callback with name ' .. name .. ' does not exist.')
        TriggerServerEvent('ps_lib:server:noCallback', name)
        return
    end

    local result = callbacks[name](...)
    TriggerServerEvent('ps_lib:Server:triggerClientCallback', name, result)
end)

RegisterNetEvent('ps_lib:client:triggerCallback', function(name, ...)
    if pendingCallbacks[name] then
        pendingCallbacks[name].promise:resolve(...)

        if pendingCallbacks[name].callback then
            pendingCallbacks[name].callback(...)
        end

        pendingCallbacks[name] = nil
    end
end)

RegisterNetEvent('ps_lib:client:noCallback', function(name, ...)
    ps.error('no server callback registered for: ' .. name)
    pendingCallbacks[name].promise:resolve(nil)
    pendingCallbacks[name] = nil
end)


-- TODO: Add Timeout function so it wont wait forever