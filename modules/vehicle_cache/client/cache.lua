
ps.isInVehicle = false

ps.vehicle = {
    vehicle = false,
    seat = false,
    name = false,
    id = false,
    class = false,
    color = false,
    doors = false,
    plate =false,
}
RegisterNetEvent('ps_lib:enteringVehicle', function(vehicle, seat, model, netId)
    ps.isInVehicle = true
    ps.vehicle = {
        vehicle = vehicle,
        seat = seat,
        name = string.lower(model),
        id = NetToVeh(netId),
        class = GetVehicleClass(vehicle),
        color = GetVehicleColours(vehicle),
        doors = GetNumberOfVehicleDoors(vehicle),
        plate = GetVehicleNumberPlateText(vehicle),

    }
end)

RegisterNetEvent('ps_lib:leftVehicle', function(vehicle, seat, model, netId)
    ps.isInVehicle = false
    ps.vehicle = {
        vehicle = false,
        seat = false,
        name = false,
        id = false,
        class = false,
        color = false,
        doors = false,
        plate = false,
    }
end)

RegisterNetEvent('ps_lib:enteringAborted', function()
    ps.isInVehicle = false
    ps.vehicle = {
         vehicle = false,
         seat = false,
         name = false,
         id = false,
         class = false,
         color = false,
         doors = false,
            plate = false,
    }
end)

RegisterNetEvent('ps_lib:enteredVehicle', function(vehicle, seat, model, netId)
    ps.isInVehicle = true
    ps.vehicle = {
        vehicle = vehicle,
        seat = seat,
        name = string.lower(model),
        id = NetToVeh(netId),
        class = GetVehicleClass(vehicle),
        color = GetVehicleColours(vehicle),
        doors = GetNumberOfVehicleDoors(vehicle),
        plate = GetVehicleNumberPlateText(vehicle),
    }
end)

function ps.vehicleData()
   if not ps.isInVehicle then
        return false
    end
    return ps.vehicle
end