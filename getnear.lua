if IsDuplicityVersion() then
    
else
    ps.debug('Loading GetNear module')
    function ps.getNearestPed(coords, distance)
        if not coords then coords = GetEntityCoords(PlayerPedId()) end
        if not distance then distance = 10.0 end
        local pedList = GetGamePool('CPed')
        local closestDistance = 1000.0
        local PED = nil
        for i = 1, #pedList do
            local ped = pedList[i]
            if ped ~= PlayerPedId() then
                local pedCoords = GetEntityCoords(ped)
                local dist = #(coords - pedCoords)
                if dist < closestDistance then
                    PED = ped
                    closestDistance = dist
                end
            end
        end
        if PED and closestDistance < distance then
            return PED, closestDistance
        else
            return 'no nearby ped', 'no nearby ped'
        end
    end
    function ps.getNearestVehicle(coords, distance)
        if not coords then coords = GetEntityCoords(PlayerPedId()) end
        if not distance then distance = 10.0 end
        local vehicleList = GetGamePool('CVehicle')
        local closestDistance = 1000.0
        local VEHICLE = nil
        for i = 1, #vehicleList do
            local vehicle = vehicleList[i]
            if vehicle ~= PlayerPedId() then
                local vehicleCoords = GetEntityCoords(vehicle)
                local dist = #(coords - vehicleCoords)
                if dist < closestDistance then
                    VEHICLE = vehicle
                    closestDistance = dist
                end
            end
        end
        if VEHICLE and closestDistance < distance then
            return VEHICLE, closestDistance
        else
            return 'no nearby vehicle', 'no nearby vehicle'
        end
    end
    function ps.getNearestPlayers(coords, distance)
        local ped = PlayerPedId()
        if not coords then coords = GetEntityCoords(ped) end
        if not distance then distance = 10.0 end

        local closestPlayers = GetActivePlayers()
        local closestDistance = 1000.0
        local closestPlayer = nil
        for k, v in ipairs(closestPlayers) do
            local playerPed = GetPlayerPed(v)
            if playerPed ~= ped then
                local playerCoords = GetEntityCoords(playerPed)
                local dist = #(coords - playerCoords)
                if dist < closestDistance then
                    closestPlayer = v
                    closestDistance = dist
                end
            end
        end
        return closestPlayer, closestDistance
    end
    function ps.getNearestObject(coords, distance)
        if not coords then coords = GetEntityCoords(PlayerPedId()) end
        if not distance then distance = 10.0 end
        local objectList = GetGamePool('CObject')
        local closestDistance = 1000.0
        local OBJECT = nil
        for i = 1, #objectList do
            local object = objectList[i]
            if object ~= PlayerPedId() then
                local objectCoords = GetEntityCoords(object)
                local dist = #(coords - objectCoords)
                if dist < closestDistance then
                    OBJECT = object
                    closestDistance = dist
                end
            end
        end
        if OBJECT and closestDistance < distance then
            return OBJECT, closestDistance
        else
            return 'no nearby object', 'no nearby object'
        end
    end
    function ps.getNearestObjectOfType(type, distance, coords)
        if not type then return end
        if not coords then coords = GetEntityCoords(PlayerPedId()) end
        if not distance then distance = 10.0 end
        print(GetClosestObjectOfType(coords.x,coords.y,coords.z, distance, type, false, false, false))
    end
    function ps.getNearbyPed(coords, distance)
        if not coords then coords = GetEntityCoords(PlayerPedId()) end
        if not distance then distance = 25.0 end
        local pedList = GetGamePool('CPed')
        local nearby = {}
        for i = 1, #pedList do
            local ped = pedList[i]
            if ped ~= PlayerPedId() then
                local pedCoords = GetEntityCoords(ped)
                local dist = #(coords - pedCoords)
                if dist < distance then
                    table.insert(nearby, {ped = ped, distance = dist})
                end
            end
        end
        if #nearby > 0 then
            return nearby
        else
            ps.notify('No Peds Nearby', 'error')
            return {}
        end
    end
    function ps.getNearbyVehicles(coords, distance)
        if not coords then coords = GetEntityCoords(PlayerPedId()) end
        if not distance then distance = 25.0 end
        local vehicleList = GetGamePool('CVehicle')
        local nearby = {}
        for i = 1, #vehicleList do
            local vehicle = vehicleList[i]
            if vehicle ~= PlayerPedId() then
                local vehicleCoords = GetEntityCoords(vehicle)
                local dist = #(coords - vehicleCoords)
                if dist < distance then
                    table.insert(nearby, {vehicle = vehicle, distance = dist})
                end
            end
        end
        if #nearby > 0 then
            return nearby
        else
            ps.notify('No Vehicles Nearby', 'error')
            return {}
        end
    end
    function ps.getNearbyObjects(coords, distance)
        if not coords then coords = GetEntityCoords(PlayerPedId()) end
        if not distance then distance = 25.0 end
        local objectList = GetGamePool('CObject')
        local nearby = {}
        for i = 1, #objectList do
            local object = objectList[i]
            if object ~= PlayerPedId() then
                local objectCoords = GetEntityCoords(object)
                local dist = #(coords - objectCoords)
                if dist < distance then
                    table.insert(nearby, {object = object, distance = dist})
                end
            end
        end
        if #nearby > 0 then
            return nearby
        else
            ps.notify('No Objects Nearby', 'error')
            return {}
        end
    end
end