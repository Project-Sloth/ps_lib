
ps.dead = false
ps.isInVehicle = false
ps.currentVehicle = 0
ps.currentSeat = 0
ps.vehicleId = 0

RegisterNetEvent('ps_lib:enteringVehicle', function(vehicle, seat, model, netId)
    ps.isInVehicle = true
    ps.currentVehicle = vehicle
    ps.currentSeat = seat
    ps.model = model
    ps.vehicleId = NetToVeh(netId)
    ps.debug(ps.isInVehicle, ps.currentVehicle, ps.currentSeat, ps.model, ps.vehicleId)
end)

RegisterNetEvent('ps_lib:leftVehicle', function(vehicle, seat, model, netId)
    ps.isInVehicle = false
    ps.currentVehicle = 0
    ps.currentSeat = 0
    ps.model = 0
    ps.vehicleId = 0
    ps.debug(ps.isInVehicle, ps.currentVehicle, ps.currentSeat, ps.model, ps.vehicleId)
end)

RegisterNetEvent('ps_lib:enteringAborted', function()
    ps.isInVehicle = false
    ps.currentVehicle = 0
    ps.currentSeat = 0
    ps.model = 0
    ps.vehicleId = 0
    ps.debug(ps.isInVehicle, ps.currentVehicle, ps.currentSeat, ps.model, ps.vehicleId)
end)

RegisterNetEvent('ps_lib:enteringVehicle', function(vehicle, seat, model, netId)
    ps.isInVehicle = true
    ps.currentVehicle = vehicle
    ps.currentSeat = seat
    ps.model = model
    ps.vehicleId = NetToVeh(netId)
    ps.debug(ps.isInVehicle, ps.currentVehicle, ps.currentSeat, ps.model, ps.vehicleId)
end)

RegisterNetEvent('ps_lib:onPlayerDied', function()
    ps.dead = true
    ps.debug("Player has died")
end)

RegisterNetEvent('ps_lib:healedPlayer', function()
    ps.dead = false
    ps.debug("Player has been healed")
end)

RegisterNetEvent('hospital:client:Revive', function()
    ps.dead = false
    ps.debug("Player has been revived")
end)