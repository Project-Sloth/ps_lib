
function ps.giveVehicleKey(vehicle)
    if not vehicle then
        return false
    end
    exports.MrNewbVehicleKeys:GiveKeys(vehicle)
end

function ps.removeVehicleKey(vehicle)
    if not vehicle then
        return false
    end
    exports.MrNewbVehicleKeys:RemoveKeys(vehicle)
end