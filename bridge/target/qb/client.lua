local zones = {}

function ps.boxTarget(name, location, size, options)
    if not name then return end
    local resource = GetInvokingResource() or GetCurrentResourceName()
    size = {
        length = size and size.length or 1.5,
        width = size and size.width or 1.5,
        height = size and size.height or 1.5,
        rotation = size and size.rotation or 180.0
    }
    if not zones[resource] then
        zones[resource] = {}
    end
    local compat = {}
    for k, v in pairs(options) do
        table.insert(compat,{
		    icon = v.icon or "fa-solid fa-eye",
            label = v.label or "Interact",
            event = v.event or nil,
            action = v.action or nil,
		    onSelect = v.action or nil,
            data = v.data or nil,
            canInteract = v.canInteract or nil,
            distance = 2.0,
	    })
    end
    zones[resource][name] = name
    exports['qb-target']:AddBoxZone(name, location, size.length, size.width, {
        name = name,
        heading = size.rotation,
        debugPoly = false,
        minZ = location.z - size.height,
        maxZ = location.z + size.height,
    }, {
        options = compat,
        distance = 2.0
    })
end

function ps.circleTarget(name, location, size, options)
    if not name then return end
    if not size then size = 1.5 end
    local resource = GetInvokingResource() or GetCurrentResourceName()
    if not zones[resource] then
        zones[resource] = {}
    end
    local compat = {}
    for k, v in pairs(options) do
        table.insert(compat,{
		    icon = v.icon or "fa-solid fa-eye",
            label = v.label,
            event = v.event or nil,
            action = v.action or nil,
		    onSelect = v.action or nil,
            data = v.data,
            canInteract = v.canInteract or nil,
            distance = 2.0,
	    })
    end
    zones[resource][name] = name
    exports['qb-target']:AddCircleZone(name, location, size, {
        name = name,
        heading = size or 180.0,
        debugPoly = false,
        useZ = true,
    }, {
        options = compat,
        distance = 2.0
    })
end

function ps.entityTarget(entity, options)
    local compat = {}
    for k, v in pairs(options) do
        table.insert(compat,{
    	    icon = v.icon or "fa-solid fa-eye",
            label = v.label,
            event = v.event or nil,
            action = v.action or nil,
    	    onSelect = v.action or nil,
            data = v.data,
            canInteract = v.canInteract or nil,
            distance = 2.0,
    	})
    end
    exports['qb-target']:AddTargetEntity(entity, {options = compat, distance = 3.5})
end

function ps.targetModel(entity, options)
    local compat = {}
    for k, v in pairs(options) do
        table.insert(compat,{
    	    icon = v.icon or "fa-solid fa-eye",
            label = v.label,
            event = v.event or nil,
            action = v.action or nil,
    	    onSelect = v.action or nil,
            data = v.data,
            canInteract = v.canInteract or nil,
            distance = 2.0,
    	})
    end
    exports['qb-target']:AddTargetModel(entity, {options = compat, distance = 3.5})
end

function ps.destroyAllTargets()
    local resource = GetInvokingResource() or GetCurrentResourceName()
    if zones[resource] then
        for k, v in pairs(zones[resource]) do
            exports['qb-target']:RemoveZone(v)
        end
        zones[resource] = nil
    end
end

function ps.destroyTarget(name)
    if not name then return end
    local resource = GetInvokingResource() or GetCurrentResourceName()
    exports['qb-target']:RemoveZone(zones[resource][name])
    zones[resource][name] = nil
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        ps.destroyAllTargets()
    end
    if zones[resourceName] then
        for k, v in pairs(zones[resourceName]) do
            exports['qb-target']:RemoveZone(v)
        end
        zones[resourceName] = nil
    end
end)