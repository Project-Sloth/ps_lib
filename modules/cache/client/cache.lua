
 ps.cache = {}
local cache = ps.cache
CreateThread(function()
    while true do
        Wait(1000)
        cache.ped = PlayerPedId()
        cache.playerId = PlayerId()
        cache.coords = GetEntityCoords(cache.ped)
        cache.vehicle = GetVehiclePedIsIn(cache.ped, false) or false
        if cache.vehicle and cache.vehicle ~= 0 then
            cache.vehicleLabel = ps.getVehicleLabel(cache.vehicle)
             cache.vehicleModel = GetEntityModel(cache.vehicle)
             cache.vehicleSeat = GetPedInVehicleSeat(cache.vehicle)
        else
            cache.vehicleLabel = false
            cache.vehicleModel = false
        end
        cache.isDead = ps.isDead()
        cache.weapon = GetSelectedPedWeapon(cache.ped)
        cache.weaponLabel = GetWeapontypeModel(cache.weapon)
    end
    
end)