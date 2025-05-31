RegisterNetEvent('baseevents:enteringVehicle', function(vehicle, seat, model, netId)
    local src = source
    TriggerClientEvent('ps_lib:enteringVehicle', src, vehicle, seat, model, netId)
end)

RegisterNetEvent('baseevents:leftVehicle', function(vehicle, seat, model, netId)
    local src = source
    TriggerClientEvent('ps_lib:leftVehicle', src, vehicle, seat, model, netId)
end)

RegisterNetEvent('baseevents:enteringAborted', function()
    local src = source
    TriggerClientEvent('ps_lib:enteringAborted', src)
end)

RegisterNetEvent('baseevents:enteredVehicle', function(vehicle, seat, model, netId)
    local src = source
    TriggerClientEvent('ps_lib:enteringVehicle', src, vehicle, seat, model, netId)
end)

RegisterNetEvent('baseevents:onPlayerDied', function(killedBy, pos)
    local src = source
    TriggerClientEvent('ps_lib:onPlayerDied', src)
end)

RegisterNetEvent('txAdmin:events:healedPlayer', function(eventData)
    if GetInvokingResource() ~= 'monitor' or type(eventData) ~= 'table' or type(eventData.id) ~= 'number' then
		return
	end
    TriggerClientEvent('ps_lib:healedPlayer', eventData.id)
end)