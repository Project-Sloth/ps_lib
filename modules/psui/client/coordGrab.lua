
local run = false
local function coordGrab()
    run = true
    repeat
        Wait(1)
        local hit, coords, surface, entity = ps.raycast()
        DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2,  0.2,  0.2, 17, 233, 196, 100)
        SendNUIMessage({
            action = 'updateCoords',
            data = { x = math.floor(coords.x * 100) / 100, y = math.floor(coords.y * 100) / 100, z = math.floor(coords.z * 100) / 100, w = GetEntityHeading(PlayerPedId()) }
        })
         if IsControlPressed(0, 23) then -- f
            SendNUIMessage({action = 'copyCoords', data = { type = 'vec3'}})
        end
        if IsControlPressed(0, 47) then -- g
            SendNUIMessage({action = 'copyCoords', data = { type = 'vec4'}})
        end
        if IsControlPressed(0, 74) then -- h
            SendNUIMessage({action = 'copyCoords', data = { type = 'vec2'}})
        end
        if IsControlPressed(0, 25) then -- right mouse button
            SendNUIMessage({action = 'copyCoords', data = { type = 'stop'}})
            run = false
        end
    until not run
end

RegisterCommand('coordGrab', function()
    if run then
        SendNUIMessage({action = 'copyCoords', data = { type = 'stop'}})
        run = false
        return
    end
    SendNUIMessage({
        action = 'coordGrabber',
        data = true
    })
    coordGrab()
end, false)