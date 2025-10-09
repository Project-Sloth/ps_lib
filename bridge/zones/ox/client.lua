ps.zones = {}
local zones = {}

function ps.zones.box(data)
    local scriptName = GetInvokingResource() or 'ps_lib'
    if not zones[scriptName] then
        zones[scriptName] = {}
    end
    local boxZone = lib.zones.box(data)
    table.insert(zones[scriptName], boxZone)
    return boxZone
end

function ps.zones.sphere(data)
    local scriptName = GetInvokingResource() or 'ps_lib'
    if not zones[scriptName] then
        zones[scriptName] = {}
    end
    local sphereZone = lib.zones.sphere(data)
    table.insert(zones[scriptName], sphereZone)
    return sphereZone
end

function ps.zones.poly(data)
    local scriptName = GetInvokingResource() or 'ps_lib'
    if not zones[scriptName] then
        zones[scriptName] = {}
    end
    local polyZone = lib.zones.poly(data)
    table.insert(zones[scriptName], polyZone)
    return polyZone
end

function ps.zones.remove(zone)
    local resourceName = GetInvokingResource() or 'ps_lib'
    if zones[resourceName] then
        for k, zones in ipairs(zones[resourceName]) do
            if zones.id == zone.id then
                zones:remove()
                break
            end
        end
    end
end

RegisterNetEvent('onResourceStop', function(resourceName)
    if zones[resourceName] then
        for _, zone in ipairs(zones[resourceName]) do
            zone:remove()
        end
        zones[resourceName] = nil
    end
end)

exports('boxZone', ps.zones.box)
exports('sphereZone', ps.zones.sphere)
exports('polyZone', ps.zones.poly)
exports('removeZone', ps.zones.remove)

ps.success('Zones Module Loaded: ox_lib Zones')