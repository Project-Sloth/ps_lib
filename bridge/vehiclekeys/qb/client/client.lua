
function ps.giveVehicleKey(vehicle)
    if not vehicle then
        return false
    end
    TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', QBCore.Functions.GetPlate(vehicle))
end

function ps.removeVehicleKey(vehicle)
    if not vehicle then
        return false
    end
    TriggerEvent('qb-vehiclekeys:client:RemoveKeys', QBCore.Functions.GetPlate(vehicle))
end

ps.success('Vehicle Keys Module Loaded: MrNewb Vehicle Keys')