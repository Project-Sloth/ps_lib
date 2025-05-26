
local run = false
function ps.coordGrab()
    run = true
    repeat
        Wait(1)
        local hit, coords, surface, entity = ps.raycast()
        DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5,  0.5,  0.5, 17, 233, 196, 100)
        SendNUIMessage({
            action = 'getCoords',
            data = { x = math.floor(coords.x * 100) / 100, y = math.floor(coords.y * 100) / 100, z = math.floor(coords.z * 100) / 100, w = GetEntityHeading(PlayerPedId()) }
        })
         if IsControlPressed(0, 38) then
            SendNUIMessage({action = 'copyCoords', data = { type = 'vec3'}})
        end
        if IsControlPressed(0, 45) then
            SendNUIMessage({action = 'copyCoords', data = { type = 'vec4'}})
        end
        if IsControlPressed(0, 49) then
            SendNUIMessage({action = 'copyCoords', data = { type = 'vec2'}})
        end
        if IsControlPressed(0, 177) then
            SendNUIMessage({action = 'copyCoords', data = { type = 'stop'}})
        end
    until not run
end

RegisterCommand('testUi', function()
    SendNUIMessage({
        action = 'setVisible',
        data = true
    })
    ps.coordGrab()
end)

RegisterNUICallback('hideUI', function(data, cb)
    SetNuiFocus(false, false)
    run = false
    cb('ok')
end)