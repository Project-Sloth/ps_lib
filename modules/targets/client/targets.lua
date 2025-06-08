local zones = {}

function ps.boxTarget(name, location, size, options)
    if not name then return end
    size = {
        length = size.length or 1.0,
        width = size.width or 1.0,
        height = size.height or 1.0,
        rotation = size.rotation or 180.0,
    }
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
    if Config.Target == 'qb' then
        zones[name] = name
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
    if Config.Target == 'ox' then
        zones[name] = exports.ox_target:addBoxZone({
            name = name,
            coords = location,
            size = vec3(size.length, size.width, size.height),
            rotation = size.rotation,
            options = compat,
            debug = false
        })
    end
    if Config.Target == 'interact' then
        zones[name] = name
        exports.interact:AddInteraction(
        {
            coords = vector3(location.x, location.y,location.z),
            distance = 8.0,
            interactDst = 2.0,
            id = name,
            name = name
        },
        {
            options = compat,
        })
    end
end

function ps.circleTarget(name, location, size, options)
    if not name then return end
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
    if Config.Target == 'qb' then
        zones[name] = name
        exports['qb-target']:AddCircleZone(name, location, size, {
            name = name,
            heading = size.rotation,
            debugPoly = false,
            useZ = true,
        }, {
            options = compat,
            distance = 2.0
        })
    end
    if Config.Target == 'ox' then
       zones[name] = exports.ox_target:addSphereZone({
            name = name,
            coords = location,
            radius = size,
            options = compat,
            debug = false
        })
    end
    if Config.Target == 'interact' then
        zones[name] = name
        exports.interact:AddInteraction(
        {
            coords = vector3(location.x, location.y,location.z),
            distance = 8.0,
            interactDst = 2.0,
            id = name,
            name = name
        },
        {
            options = compat,
        })
    end
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
    if Config.Target == 'ox' then
        exports.ox_target:addLocalEntity(entity, compat)
    elseif Config.Target == 'qb' then
        	exports['qb-target']:AddTargetEntity(entity, {options = compat, distance = 3.5})
    elseif Config.Target == 'interaction' then
        exports.interact:AddLocalEntityInteraction({entity = entity, name = entity, id = entity, distance = 8.0, interactDst = 2.0, options = compat})
    end
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
    if Config.Target == 'ox' then 
        exports.ox_target:addModel(entity, compat)
    elseif Config.Target == 'qb' then
        exports['qb-target']:AddTargetModel(entity, {options = compat, distance = 3.5})
    elseif Config.Target == 'interaction' then
        exports.interact:AddTargetModel(entity, {options = compat, distance = 3.5})
    end
end

function ps.destroyAllTargets()
    for k, v in pairs(zones) do
        if Config.Target == 'qb' then
            exports['qb-target']:RemoveZone(v)
        elseif Config.Target == 'ox' then
            exports.ox_target:removeZone(v)
        elseif Config.Target == 'interact' then
            exports.interact:RemoveInteraction(v)
        end
    end
end

function ps.destroyTarget(name)
    if not name then return end
    if Config.Target == 'qb' then
        exports['qb-target']:RemoveZone(name)
    elseif Config.Target == 'ox' then
        exports.ox_target:removeZone(name)
    elseif Config.Target == 'interact' then
        exports.interact:RemoveInteraction(name)
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        ps.destroyAllTargets()
    end
end)