ps.loadFile('PolyZone', 'client.lua')
ps.loadFile('PolyZone', 'BoxZone.lua')
ps.loadFile('PolyZone', 'EntityZone.lua')
ps.loadFile('PolyZone', 'CircleZone.lua')
ps.loadFile('PolyZone', 'ComboZone.lua')

ps.zones = {}
local zones = {}

local isInsideZone = false
local function inside(func)
    CreateThread(function()
        while isInsideZone do
            Wait(0)
            func()
        end
    end)
end

function ps.zones.box(data)
    local scriptName = GetInvokingResource() or 'ps_lib'
    if not zones[scriptName] then
        zones[scriptName] = {}
    end
    if not data.size then
        data.size = vec3(5.0, 5.0, 4.0)
    end
    local boxZone = BoxZone:Create(data.coords, data.size.x, data.size.y, {
        name = data.id or scriptName .. '_' .. #zones[scriptName]+1,
        debugPoly = data.debug or false,
        heading = data.rotation or 0.0,
        minZ = data.coords.z - data.size.z / 2,
        maxZ = data.coords.z + data.size.z / 2,
    })
    zones[scriptName][#zones[scriptName]+1] = boxZone
    boxZone:onPlayerInOut(function(isInside, _)
        if isInside then
            if data.onEnter then
                data.onEnter()
            end
            if data.inside then
                isInsideZone = true
                inside(data.inside)
            end
        else
            if data.onExit then
                 data.onExit()
            end
            if data.inside then
                isInsideZone = false
            end
        end
    end)
    return boxZone
end

function ps.zones.sphere(data)
    local scriptName = GetInvokingResource() or 'ps_lib'
    if not zones[scriptName] then
        zones[scriptName] = {}
    end
    if not data.radius then
        data.radius = 20.0
    end
    local sphereZone = CircleZone:Create(data.coords, data.radius, {
        name = data.id or scriptName .. '_' .. #zones[scriptName]+1,
        debugPoly = data.debug or false,
    })
    zones[scriptName][#zones[scriptName]+1] = sphereZone
    sphereZone:onPlayerInOut(function(isInside, _)
        if isInside then
            if data.onEnter then
                data.onEnter()
            end
            if data.inside then
                isInsideZone = true
                inside(data.inside)
            end
        else
            if data.onExit then
                 data.onExit()
            end
            if data.inside then
                isInsideZone = false
            end
        end
    end)
    return sphereZone
end

function ps.zones.poly(data)
    local scriptName = GetInvokingResource() or 'ps_lib'
    if not zones[scriptName] then
        zones[scriptName] = {}
    end
    local pointZ = data.points[1].z or 0.0
    if not data.thickness then
        data.thickness = 4.0
    end

    local polyZone = PolyZone:Create(data.points, {
        name = data.id or scriptName .. '_' .. #zones[scriptName]+1,
        debugPoly = data.debug or false,
        minZ = pointZ - (data.thickness / 2),
        maxZ = pointZ + (data.thickness / 2),
    })
    zones[scriptName][#zones[scriptName]+1] = polyZone
    polyZone:onPlayerInOut(function(isInside, _)
        if isInside then
            if data.onEnter then
                data.onEnter()
            end
            if data.inside then
                isInsideZone = true
                inside(data.inside)
            end
        else
            if data.onExit then
                 data.onExit()
            end
            if data.inside then
                isInsideZone = false
            end
        end
    end)
    return polyZone
end

function ps.zones.remove(zone)
    local resourceName = GetInvokingResource() or 'ps_lib'
    if zones[resourceName] then
        for k, zones in ipairs(zones[resourceName]) do
            if zones.id == zone.id then
                zones:destroy()
                break
            end
        end
    end
end

RegisterNetEvent('onResourceStop', function(resourceName)
    if zones[resourceName] then
        for _, zone in ipairs(zones[resourceName]) do
            zone:destroy()
        end
        zones[resourceName] = nil
    end
end)

exports('boxZone', ps.zones.box)
exports('sphereZone', ps.zones.sphere)
exports('polyZone', ps.zones.poly)
exports('removeZone', ps.zones.remove)